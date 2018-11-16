--Write the SQL query to determine which students were born after November 5, 1996.
Select * FROM tblSTUDENT
WHERE StudentBirth > '1996-11-5'


--Write the SQL query to determine which buildings are on West Campus.
SELECT * FROM tblLOCATION INNER JOIN tblBUILDING ON
tblBUILDING.LocationID=tblLOCATION.LocationID
WHERE LocationName = 'West Campus'


--Write the SQL query to determine how many libraries are at UW.
SELECT * FROM tblBUILDING_TYPE INNER JOIN tblBUILDING ON
tblBUILDING.BuildingTypeID=tblBUILDING_TYPE.BuildingTypeID
WHERE BuildingTypeName = 'Library'


--Write the code to return the 10 youngest students living in West Campus and during winter quarter 2009.
SELECT TOP 10 * FROM tblSTUDENT S
INNER JOIN tblSTUDENT_DORMROOM SD ON S.StudentID = SD.StudentID
INNER JOIN tblDORMROOM M ON SD.DormRoomID=M.DormRoomID
INNER JOIN tblBUILDING B ON M.BuildingID=B.BuildingID
INNER JOIN tblLOCATION L ON B.LocationID=L.LocationID
INNER JOIN tblCLASSROOM CR ON CR.BuildingID=B.BuildingID
INNER JOIN tblCLASS C ON C.ClassroomID=CR.ClassroomID
INNER JOIN tblQUARTER Q ON Q.QuarterID=C.QuarterID
WHERE L.LocationName = 'West Campus' 
AND Q.QuarterName = 'WINTER'
AND C.YEAR = 2009
ORDER BY StudentBirth ASC


--Write the code that exhibits the 5 oldest buildings on UW campus by the year that they were opened.
SELECT TOP 5 * FROM tblBUILDING
ORDER BY tblBUILDING.YearOpened ASC


--Write the code to determine the 5 most-common states listed as permanent addresses for students who registered for at least one course in the 1930's.
SELECT TOP 5 StudentPermState, COUNT(StudentPermState) AS total FROM tblSTUDENT S
INNER JOIN tblSTUDENT_CONTACT SC ON SC.StudentID=S.StudentID
INNER JOIN tblCONTACT C ON C.ContactID=SC.ContactID
GROUP BY StudentPermState
ORDER BY total DESC


--Write the SQL query to list the Department that hired the most people to the position type 'Executive' between June 8, 1968 and March 6, 1989.
SELECT TOP 1 DeptName, COUNT(DeptName) AS total FROM tblPOSITION_TYPE PT 
INNER JOIN tblPOSITION P ON P.PositionTypeID=PT.PositionTypeID
INNER JOIN tblSTAFF_POSITION SP ON SP.PositionID=P.PositionID
INNER JOIN tblDEPARTMENT D ON D.DeptID=SP.DeptID
WHERE PT.PositionTypeName = 'Executive'
AND BeginDate BETWEEN '1968-06-08' AND '1989-03-06'
GROUP BY DeptName
ORDER BY total DESC

--Write the SQL query to determine which current instructor has been a Senior Lecturer the longest. 
SELECT TOP 1 * FROM tblINSTRUCTOR
INNER JOIN tblINSTRUCTOR_INSTRUCTOR_TYPE ON tblINSTRUCTOR.InstructorID = tblINSTRUCTOR_INSTRUCTOR_TYPE.InstructorID
INNER JOIN tblINSTRUCTOR_TYPE ON tblINSTRUCTOR_INSTRUCTOR_TYPE.InstructorTypeID=tblINSTRUCTOR_TYPE.InstructorTypeID
WHERE tblINSTRUCTOR_TYPE.InstructorTypeName = 'Lecturer'
AND tblINSTRUCTOR_INSTRUCTOR_TYPE.EndDate IS NULL
ORDER BY tblINSTRUCTOR_INSTRUCTOR_TYPE.BeginDate


--Write the SQL query to determine which College offer the most courses Spring quarter 2014.
SELECT TOP 1 CollegeName, COUNT(CollegeName) AS total FROM tblCOLLEGE C
INNER JOIN tblDEPARTMENT D ON D.CollegeID=C.CollegeID
INNER JOIN tblCOURSE CR ON CR.DeptID=D.DeptID
INNER JOIN tblCLASS CL ON CL.CourseID=CR.CourseID
INNER JOIN tblQUARTER Q ON Q.QuarterID=CL.QuarterID
WHERE YEAR=2014
AND QuarterName='Spring'
GROUP BY CollegeName
ORDER BY total DESC


--Write the SQL query to determine which courses were held in large lecture halls or auditorium type classrooms summer 2016. 
SELECT * FROM tblQUARTER Q
INNER JOIN tblCLASS CL ON CL.QuarterID=Q.QuarterID
INNER JOIN tblCLASSROOM CR ON CR.ClassroomID=CL.ClassroomID
INNER JOIN tblCLASSROOM_TYPE CT ON CT.ClassroomTypeID=CR.ClassroomTypeID
WHERE YEAR = '2016'
AND QuarterName = 'Summer'
AND ClassroomTypeName='Auditorium' 
OR ClassroomTypeName='Large Lecture Hall'
