--Write the query to determine the number of faculty in the School of Medicine hired before November 21, 2016. 
SELECT CL.CollegeName, COUNT(*) AS NumFaculty FROM tblCOLLEGE CL
    JOIN tblDEPARTMENT D ON D.CollegeID=CL.CollegeID
    JOIN tblSTAFF_POSITION SP ON SP.DeptID=D.DeptID
WHERE CL.CollegeName='Medicine'
    AND SP.BeginDate < '2016-11-21'
GROUP BY CL.CollegeName

--Write the query to determine the number of Administrative staff people were hired in the Medical School 
--between February 12, 2009 and March 28, 2013? 
SELECT C.CollegeName, COUNT(*) AS NumAdministrativeStaff FROM tblPOSITION P
    JOIN tblSTAFF_POSITION SP ON SP.PositionID=P.PositionID
    JOIN tblDEPARTMENT D ON D.DeptID=SP.DeptID
    JOIN tblCOLLEGE C ON C.CollegeID=D.CollegeID
WHERE P.PositionName='Administrative-Assistant'
    AND C.CollegeName='Medicine'
    AND (SP.BeginDate BETWEEN '2009-02-12' AND '2013-03-28')
GROUP BY C.CollegeName

--Write the query to determine the newest building on lower campus that has had a Geology class instructed 
--by Greg Hay before winter 2015. 
SELECT TOP 1 WITH TIES B.BuildingName, B.YearOpened FROM tblINSTRUCTOR I 
    JOIN tblINSTRUCTOR_CLASS IC ON IC.InstructorID=I.InstructorID
    JOIN tblCLASS C ON C.ClassID=IC.ClassID
    JOIN tblQUARTER Q ON Q.QuarterID=C.QuarterID
    JOIN tblCOURSE CR ON CR.CourseID=C.CourseID
    JOIN tblDEPARTMENT D ON D.DeptID=CR.DeptID
    JOIN tblCLASSROOM CLR ON CLR.ClassroomID=C.ClassroomID
    JOIN tblBUILDING B ON B.BuildingID=CLR.BuildingID
    JOIN tblLOCATION L ON L.LocationID=B.LocationID
WHERE I.InstructorFName='Greg'
    AND I.InstructorLName='Hay'
    AND C.YEAR < 2015
    AND D.DeptName='Geography'
    AND L.LocationName='South Campus'
ORDER BY B.YearOpened ASC
    

--Write the query to determine which instructor has had the same office in Padelford Hall the longest.
SELECT TOP 1 I.InstructorID, I.InstructorFName, I.InstructorLName, DATEDIFF(DAY, INO.BeginDate, INO.EndDate) AS NumDays FROM tblINSTRUCTOR I
    JOIN tblINSTRUCTOR_OFFICE INO ON INO.InstructorID=I.InstructorID
    JOIN tblOFFICE O ON O.OfficeID=INO.OfficeID
    JOIN tblBUILDING B ON B.BuildingID=O.BuildingID
WHERE B.BuildingName='Padelford Hall'
ORDER BY NumDays DESC


--Write the query to determine which 3 classroom types are most-frequently assigned for 400-level Psychology courses
SELECT TOP 3 WITH TIES CRT.ClassroomTypeName, COUNT(*) AS NumClasses FROM tblDEPARTMENT D 
    JOIN tblCOURSE CR ON CR.DeptID=D.DeptID
    JOIN tblCLASS C ON C.CourseID=CR.CourseID
    JOIN tblCLASSROOM CLR ON CLR.ClassroomID=C.ClassroomID
    JOIN tblCLASSROOM_TYPE CRT ON CRT.ClassroomTypeID=CLR.ClassroomTypeID
WHERE CR.CourseName LIKE '%4__'
    AND D.DeptName='Psychology'
GROUP BY CRT.ClassroomTypeName
ORDER BY NumClasses DESC


--Write the code to create a stored procedure to hire a new person to an existing staff position.
ALTER PROCEDURE usp_rioishii_newstaff
@StaffFName varchar(45),
@StaffLName varchar(45), 
@StaffAddress varchar(45), 
@StaffCity varchar(45), 
@StaffState char(2), 
@StaffZip varchar(30), 
@StaffBirth Date, 
@StaffNetID varchar(20), 
@StaffEmail varchar(30), 
@Gender CHAR(1),
@PositionName varchar(30),
@DepartmentName varchar(30)
AS
INSERT INTO dbo.tblSTAFF (StaffFname, StaffLname, StaffAddress, StaffCity, StaffState, StaffZip, StaffBirth, StaffNetID, StaffEmail, Gender)
VALUES(@StaffFName, @StaffLName, @StaffAddress, @StaffCity, @StaffState, @StaffZip, @StaffBirth, @StaffNetID, @StaffEmail, @Gender)
DECLARE @StaffID INT = SCOPE_IDENTITY()
DECLARE @PositionID INT = (SELECT PositionID FROM tblPOSITION WHERE PositionName = @PositionName)
DECLARE @DeptID INT = (SELECT DeptID FROM tblDEPARTMENT WHERE DeptName = @DepartmentName)
INSERT INTO dbo.tblSTAFF_POSITION (StaffID, PositionID, BeginDate, EndDate, DeptID)
VALUES(@StaffID, @PositionID, NULL, NULL, @DeptID)

GO

EXEC usp_rioishii_newstaff
@StaffFName = 'Rio',
@StaffLName = 'Ishii', 
@StaffAddress = 'House', 
@StaffCity = 'Seattle', 
@StaffState = 'WA', 
@StaffZip = '111111', 
@StaffBirth = '1998-4-20', 
@StaffNetID = 'ddddd', 
@StaffEmail = 'ddddd@uw.edu', 
@Gender = 'M',
@PositionName = 'Researcher',
@DepartmentName ='Art'

GO

--Write the code to create a stored procedure to create a new class of an existing course.
CREATE PROCEDURE usp_rioishii_newclass
@CourseName varchar(45),
@QuarterName varchar(45),
@YEAR INT,
@ClassroomName varchar(45),
@ScheduleName varchar(45),
@Section varchar(45)
AS
DECLARE @CourseID INT = (SELECT CourseID FROM tblCOURSE WHERE CourseName=@CourseName)
DECLARE @QuarterID INT = (SELECT QuarterID FROM tblQUARTER WHERE QuarterName=@QuarterName)
DECLARE @ClassroomID INT = (SELECT ClassroomID FROM tblCLASSROOM WHERE ClassroomName=@ClassroomName)
DECLARE @ScheduleID INT = (SELECT ScheduleID FROM tblSCHEDULE WHERE ScheduleName=@ScheduleName)
INSERT INTO tblCLASS (CourseID, QuarterID, YEAR, ClassroomID, ScheduleID, Section)
VALUES (@CourseID, @QuarterID, @YEAR, @ClassroomID, @ScheduleID, @Section)

GO

EXEC usp_rioishii_newclass
@CourseName = 'ASIAN156',
@QuarterName = 'Spring',
@YEAR = 2018,
@ClassroomName = 'HUT198',
@ScheduleName = 'MonFri5P',
@Section = 'E'

GO

--Write the code to create a stored procedure to register an existing student to an existing class.
CREATE PROCEDURE usp_rioishii_registerstudent
@CourseName varchar(45),
@QuarterName varchar(45),
@YEAR INT,
@ClassroomName varchar(45),
@ScheduleName varchar(45),
@Section varchar(45),
@Grade FLOAT,
@RegistrationDate DATE,
@StudentFname varchar(30),
@StudentLname varchar(30),
@StudentBirth DATE
AS
DECLARE @CourseID INT = (SELECT CourseID FROM tblCOURSE WHERE CourseName=@CourseName)
DECLARE @QuarterID INT = (SELECT QuarterID FROM tblQUARTER WHERE QuarterName=@QuarterName)
DECLARE @ClassroomID INT = (SELECT ClassroomID FROM tblCLASSROOM WHERE ClassroomName=@ClassroomName)
DECLARE @ScheduleID INT = (SELECT ScheduleID FROM tblSCHEDULE WHERE ScheduleName=@ScheduleName)
DECLARE @ClassID INT = (SELECT ClassID FROM tblCLASS
    WHERE CourseID = @CourseID
    AND QuarterID = @QuarterID
    AND YEAR = @YEAR
    AND ClassroomID = @ClassroomID
    AND ScheduleID = @ScheduleID
    AND Section = @Section)
DECLARE @StudentID INT = (SELECT StudentID FROM tblSTUDENT
    WHERE StudentFname = @StudentFname
    AND StudentLname = @StudentLname
    AND StudentBirth = @StudentBirth)
INSERT INTO tblCLASS_LIST(ClassID, StudentID, Grade, RegistrationDate)
VALUES (@ClassID, @StudentID, @Grade, @RegistrationDate)

GO

EXEC usp_rioishii_registerstudent
@CourseName = 'ASIAN156',
@QuarterName = 'Spring',
@YEAR = 2018,
@ClassroomName = 'HUT198',
@ScheduleName = 'MonFri5P',
@Section = 'E',
@Grade = '4.0',
@RegistrationDate = '2018-04-01',
@StudentFname = 'Damien',
@StudentLname = 'Rusiecki',
@StudentBirth = '1877-01-06'

GO
