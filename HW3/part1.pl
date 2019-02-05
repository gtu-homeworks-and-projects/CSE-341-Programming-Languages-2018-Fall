:- dynamic(room_capacity/2).
:- dynamic(room_equipment/2).

room_capacity(z06, 10).
room_capacity(z11, 10).
room_equipment(z06, projector).
room_equipment(z06, hCAPPED).
room_equipment(z11, hCAPPED).
room_equipment(z11, smartboard).

room(X, A, B) :- findall(Capacity, room_capacity(X, Capacity), A), 
                 findall(Equipment, room_equipment(X, Equipment), B).

:- dynamic(course_instructor/2).
:- dynamic(course_capacity/2).
:- dynamic(course_hour/2).
:- dynamic(course_equipment/2).
:- dynamic(course_room/2).
course_instructor(cse341, genc).
course_instructor(cse343, turker).
course_instructor(cse331, bayrakci).
course_instructor(cse321, gozupek).
course_capacity(cse341, 10).
course_capacity(cse343, 6).
course_capacity(cse331, 5).
course_capacity(cse321, 10).
course_hour(cse341, 4).
course_hour(cse343, 3).
course_hour(cse331, 3).
course_hour(cse321, 4).
course_room(cse341, z06).
course_room(cse343, z11).
course_room(cse331, z06).
course_room(cse321, z11).


:- dynamic(instructor_course/2).
:- dynamic(instructor_equipment/2).
instructor_course(genc, cse341).
instructor_course(turker, cse343).
instructor_course(bayrakci, cse331).
instructor_course(gozupek, cse321).
instructor_equipment(genc, projector).
instructor_equipment(turker, smartboard).
instructor_equipment(gozupek, smartboard).

:- dynamic(student_course/2).
:- dynamic(student_handicapped/1).
student_course(1, cse341).
student_course(1, cse343).
student_course(1, cse331).
student_course(2, cse341).
student_course(2, cse343).
student_course(3, cse341).
student_course(3, cse331).
student_course(4, cse341).
student_course(5, cse343).
student_course(5, cse331).
student_course(6, cse341).
student_course(6, cse343).
student_course(6, cse331).
student_course(7, cse341).
student_course(7, cse343).
student_course(8, cse341).
student_course(8, cse331).
student_course(9, cse341).
student_course(10, cse341).
student_course(10, cse321).
student_course(11, cse341).
student_course(11, cse321).
student_course(12, cse343).
student_course(12, cse321).
student_course(13, cse343).
student_course(13, cse321).
student_course(14, cse343).
student_course(14, cse321).
student_course(15, cse343).
student_course(15, cse321).
student_handicapped(6).
student_handicapped(8).
student_handicapped(15).

:- dynamic(occupancy_hour/3).
occupancy_hour(z06, 8, cse341).
occupancy_hour(z06, 9, cse341).
occupancy_hour(z06, 10, cse321).
occupancy_hour(z06, 11, cse341).
occupancy_hour(z06, 13, cse331).
occupancy_hour(z06, 14, cse331).
occupancy_hour(z06, 15, cse331).
occupancy_hour(z11, 8, cse343).
occupancy_hour(z11, 9, cse343).
occupancy_hour(z11, 10, cse343).
occupancy_hour(z11, 11, cse343).
occupancy_hour(z11, 14, cse321).
occupancy_hour(z11, 15, cse321).
occupancy_hour(z11, 16, cse321).

% Checks if given Student can enroll to a given Class or which classes.
enroll(Student, Course) :- course_is_valid(Course),
                                        not(student_course(Student, Course)),
                                        not(course_is_full(Course)),
                                        student_can_attend_classroom(Student, Course).

student_can_attend_classroom(Student, Course) :- student_handicapped(Student), course_room(Course,Room), room_equipment(Room, hCAPPED),!; \+ student_handicapped(Student), !. 

course_is_full(Course) :- findall(S, student_course(S, Course), Students), length(Students, N), 
                          course_capacity(Course, Capacity), N >= Capacity.

course_is_valid(Course) :- findall(C, course_capacity(C, _), Courses), member(Course, Courses).

room_is_valid(Room) :- findall(R, room_capacity(R, _), Rooms), member(Room, Rooms).



% Checks if a room can be assigned to a course or not
assign(Room, Course) :- course_is_valid(Course),
                        room_is_valid(Room),
                        room_can_hold_course_capacity(Room, Course),
                        room_met_instructor_requirements(Room, Course),
                        room_met_student_requirements(Room, Course).


room_can_hold_course_capacity(Room, Course) :- course_capacity(Course, N1), 
                                                room_capacity(Room, N2),
                                                N1 =< N2.

room_met_instructor_requirements(Room, Course) :- course_instructor(Course, X),
                                                    instructor_equipment(X, IE),
                                                    findall(E, room_equipment(Room, E), Equipments), member(IE, Equipments).

room_met_student_requirements(_, Course) :- \+ course_contains_hcapped_student(Course).
room_met_student_requirements(Room, Course) :- course_contains_hcapped_student(Course), room_equipment(Room, hCAPPED).

course_contains_hcapped_student(Course) :- findall(S, student_course(S, Course), CourseStudents),
                                            findall(S, student_handicapped(S), HandicappedStudents),
                                            intersection(CourseStudents, HandicappedStudents, Set3),
                                            length(Set3, N), N > 0.



% Checks if there is any conflict between Courses.
conflict(Course1, Course2) :- course_is_valid(Course1), course_is_valid(Course2), \+ Course1 = Course2,
                                    occupancy_hour(Room, Hour, Course1), occupancy_hour(Room, Hour, Course2).


% Adds a room.
add_room(RoomId, Capacity, Equipments) :- assertz(room_capacity(RoomId, Capacity)),
                                            add_room_equipments(RoomId, Equipments).

add_room_equipments(RoomId, [X|Equipments]) :- assertz(room_equipment(RoomId, X)),
                                                add_room_equipments(RoomId, Equipments).
add_room_equipments(_, []) :- !.

% Adds a course
add_course(CourseId, CourseInstructor, Capacity, Hours, Room) :- assertz(course_instructor(CourseId, CourseInstructor)),
                                                                assertz(course_capacity(CourseId, Capacity)),
                                                                assertz(course_room(CourseId, Room)),
                                                                add_course_hours(CourseId, Hours).

add_course_hours(CourseId, [X| Hours]) :- assertz(course_hour(CourseId, X)),
                                            add_course_hours(CourseId, Hours).
add_course_hours(_, []) :- !.

% Adds a student
add_student(StudentId, Courses, Handicapped) :- add_student_courses(StudentId, Courses),
                                                Handicapped = true, assertz(student_handicapped(StudentId)). 

add_student_courses(StudentId, [X| Courses]) :- assertz(student_course(StudentId, X)),
                                                add_student_courses(StudentId, Courses).
add_student_courses(_, []) :- !.