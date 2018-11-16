--1.	Write the query to determine the most-frequent classroom type assigned to business classes 
--held since 1996 during summer quarters.

SELECT Top 1 with ties CT.ClassroomTypeName, COUNT(CT.ClassroomTypeName) AS total FROM tblCLASSROOM_TYPE
    JOIN tblCLASSROOM C ON C.ClassroomTypeName=CT.ClassroomTypeName
    JOIN tblCLASS R ON R.ClassroomID=C.ClassroomID
    JOIN tblQUARTER Q ON Q.QuarterID=R.QuarterID
    JOIN tblCOURSE CR ON CR.CourseID=Q.CourseID
    JOIN tblDEPARTMENT D ON D.DeptID=CR.DeptID
WHERE Q.QuarterName='Summer'
AND C.YEAR > 1996
GROUP BY CT.ClassroomTypeName
ORDER BY total DESC

--2.	Write the query to determine the 2 most-common special-needs for students with 
--permanent addresses in either California or Texas born between March 6, 1989 and June 4, 2000.

SELECT Top 2 with ties SN.SpecialNeedName, COUNT(SN.SpecialNeedName) AS total FROM tblSPECIAL_NEED SN
    JOIN tblSTUDENT_SPECIAL_NEED SSN ON SSN.SpecialNeedID=SN.SpecialNeedID
    JOIN tblSTUDENT S ON S.StudentID=SSN.StudentID
WHERE S.StudentDateOfBirth BETWEEN '1989-03-06' AND '2000-06-04'
AND (S.StudentState = 'California' OR S.StudentState = 'Texas')
GROUP BY SN.SpecialNeedName
ORDER BY total DESC

--3.	Write the query to determine the youngest instructor with an office type of executive 
--suite on West Campus.

SELECT Top 1 with ties * FROM tblINTSTRUCTOR I 
    JOIN tblINSTRUCTOR_OFFICE IO ON IO.InstructorID=I.InstructorID
    JOIN tblOFFICE_TYPE OT ON OT.OfficeTypeID=IO.OfficeTypeID
    JOIN tblOFFICE O ON O.OfficeID=IO.OfficeID
    JOIN tblBUILDING B ON B.BuildingID=O.BuildingID
    JOIN tblLOCATION L ON L.LocationID=B.LocationID
WHERE OT.OfficeTypeName='Executive'
AND L.LocationName='West Campus'
ORDER BY I.InstructorDateOfBirth ASC

--4.	Write the query to determine the number of 300-Level accounting classes with a scheduled 
--BeginTime before 11:30 AM any autumn quarter in Lowe Hall during 1990’s.

SELECT COUNT(CourseID) FROM tblCOURSE C 
    JOIN tblCLASS CL ON CL.CourseID=C.ClassID
    JOIN tblSCHEDULE S ON S.ScheduleID=CL.ScheduleID
    JOIN tblDEPARTMENT D ON D.DeptID=C.DeptID
    JOIN tblQUARTER Q ON Q.QuarterID=CL.QuarterID
    JOIN tblCLASSROOM CR ON CR.ClassroomID=CL.ClassroomID
    JOIN tblBUILDING B ON B.BuildingID=CR.BuildingID
WHERE C.CourseName LIKE '%3__'
AND D.DeptName='Accounting'
AND B.BuildingName='Lowe Hall'
AND S.BeginTime < "11:30:00"
AND Q.QuarterName='Autumn'
AND CL.YEAR BETWEEN 1990 AND 1999


--5.	Write the query to determine the oldest person registered for MATH389 Spring 2016.

SELECT Top 1 with ties S.StudentID, S.StudentFname, S.StudentLname FROM tblSTUDENT S
    JOIN tblCLASS_LIST CL ON CL.StudentID=S.StudentID
    JOIN tblCLASS C ON C.ClassID=CL.ClassID
    JOIN tblQUARTER Q ON Q.QuarterID=C.QuarterID
    JOIN tblCOURSE CR ON CR.CourseID=C.CourseID
WHERE Q.QuarterName='Spring'
AND C.YEAR = 2016
AND CR.CourseName='MATH389'
ORDER BY S.StudentDateOfBirth DESC

--6.	Write query to determine total number of dorm rooms of type 'triple' for McMahon Hall.

SELECT COUNT(DR.DormroomID) FROM tblDORMROOM DR 
    JOIN tblDORM_TYPE DT ON DT.DormTypeID=DR.DormTypeID
    JOIN tblBUILDING B ON B.BuildlingID=DR.BuildlingID
WHERE DT.DormTypeName='Triple'
AND B.BuildingName='McMahon Hall'

--7.	Write the query to list the ratio of female-to-male students in each college for students 
--with the status of ‘suspended’ during April 2015.

SELECT COUNT(StudentID) FROM tblSTUDENT S 
    JOIN tblSTUDENT_STATUS SS ON SS.StudentID=S.StudentID
    JOIN tblSTATUS ST ON ST.StatusID=SS.StatusID
WHERE ST.StatusName='Suspended'
AND SS.BeginDate >= '2015-04-01'
AND SS.EndDate <= '2015-04-30'
GROUP BY S.Gender

--8.	Write the query to determine the number of faculty in the School of Medicine hired 
--before November 21, 2016.

SELECT COUNT(StaffID) FROM tblSTAFF S 
    JOIN tblSTAFF_POSITION SP ON SP.StaffID=S.StaffID
    JOIN tblDEPARTMENT D ON D.DeptID=SP.DeptID
    JOIN tblCOLLEGE C ON C.CollegeID=D.CollegeID
WHERE C.CollegeName='Medicine'
AND SP.StaffPosBeginDate < '2016-11-21'

--9.	Write the query to determine the number of Administrative staff people were hired 
--in the Medical School between February 12, 2009 and March 28, 2013?

SELECT COUNT(StaffID) FROM tblSTAFF S 
    JOIN tblSTAFF_POSITION SP ON SP.StaffID=S.StaffID
    JOIN tblPOSITION P ON P.PositionID=SP.PositionID
    JOIN tblPOSITION_TYPE PT ON PT.PositionTypeID=P.PositiontypeID
    JOIN tblDEPARTMENT D ON D.DeptID=SP.DeptID
    JOIN tblCOLLEGE C ON C.CollegeID=D.CollegeID
WHERE PT.PositionTypeName='Administrative'
AND C.CollegeName='Medicine'
AND SP.StaffPosBeginDate BETWEEN '2009-02-12' AND '2013-03-28'

--10.	Write the query to determine the newest building on lower campus that has had 
--a Geology class instructed by Greg Hay before winter 2015.

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

--11.	Write the query to determine which instructor has had the same office in Padelford Hall the longest.

SELECT TOP 1 I.InstructorID, I.InstructorFName, I.InstructorLName, DATEDIFF(DAY, INO.BeginDate, INO.EndDate) AS NumDays FROM tblINSTRUCTOR I
    JOIN tblINSTRUCTOR_OFFICE INO ON INO.InstructorID=I.InstructorID
    JOIN tblOFFICE O ON O.OfficeID=INO.OfficeID
    JOIN tblBUILDING B ON B.BuildingID=O.BuildingID
WHERE B.BuildingName='Padelford Hall'
ORDER BY NumDays DESC

--12.	Write the query to determine which 3 classroom types are most-frequently assigned for 400-level Psychology courses.  

SELECT TOP 3 WITH TIES CRT.ClassroomTypeName, COUNT(*) AS NumClasses FROM tblDEPARTMENT D 
    JOIN tblCOURSE CR ON CR.DeptID=D.DeptID
    JOIN tblCLASS C ON C.CourseID=CR.CourseID
    JOIN tblCLASSROOM CLR ON CLR.ClassroomID=C.ClassroomID
    JOIN tblCLASSROOM_TYPE CRT ON CRT.ClassroomTypeID=CLR.ClassroomTypeID
WHERE CR.CourseName LIKE '%4__'
    AND D.DeptName='Psychology'
GROUP BY CRT.ClassroomTypeName
ORDER BY NumClasses DESC

--13.	Create a stored procedure to hire a new person to an existing staff position. 

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
BEGIN TRAN t1
INSERT INTO dbo.tblSTAFF (StaffFname, StaffLname, StaffAddress, StaffCity, StaffState, StaffZip, StaffBirth, StaffNetID, StaffEmail, Gender)
VALUES(@StaffFName, @StaffLName, @StaffAddress, @StaffCity, @StaffState, @StaffZip, @StaffBirth, @StaffNetID, @StaffEmail, @Gender)
DECLARE @StaffID INT = SCOPE_IDENTITY()
DECLARE @PositionID INT = (SELECT PositionID FROM tblPOSITION WHERE PositionName = @PositionName)
DECLARE @DeptID INT = (SELECT DeptID FROM tblDEPARTMENT WHERE DeptName = @DepartmentName)
INSERT INTO dbo.tblSTAFF_POSITION (StaffID, PositionID, BeginDate, EndDate, DeptID)
VALUES(@StaffID, @PositionID, NULL, NULL, @DeptID)

GO

IF @@ERROR <> 0 
    ROLLBACK TRAN t1
ELSE 
    COMMIT TRAN t1

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

--14.	Create a stored procedure to create a new class of an existing course.

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
BEGIN TRAN t1
INSERT INTO tblCLASS (CourseID, QuarterID, YEAR, ClassroomID, ScheduleID, Section)
VALUES (@CourseID, @QuarterID, @YEAR, @ClassroomID, @ScheduleID, @Section)

GO

IF @@ERROR <> 0 
    ROLLBACK TRAN t1
ELSE 
    COMMIT TRAN t1

EXEC usp_rioishii_newclass
@CourseName = 'ASIAN156',
@QuarterName = 'Spring',
@YEAR = 2018,
@ClassroomName = 'HUT198',
@ScheduleName = 'MonFri5P',
@Section = 'E'

GO

--15.	Create a stored procedure to register an existing student to an existing class.

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
BEGIN TRAN t1
INSERT INTO tblCLASS_LIST(ClassID, StudentID, Grade, RegistrationDate)
VALUES (@ClassID, @StudentID, @Grade, @RegistrationDate)

GO

IF @@ERROR <> 0 
    ROLLBACK TRAN t1
ELSE 
    COMMIT TRAN t1

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

--16.	Create check constraint to restrict the type of instructor assigned to 400-level 
--courses in Biology or Philosophy courses during summer quarters to Assistant or Associate Professor.

CREATE FUNCTION fn_noBioPhil()
RETURNS INT
AS
BEGIN
DECLARE @Ret INT = 0
IF EXISTS(SELECT * FROM tblINSTRUCTOR_CLASS IC
            JOIN tblCLASS C ON C.ClassID=IC.ClassID
            JOIN tblCOURSE CR ON CR.CourseID=C.CourseID
            JOIN tblDEPARTMENT D ON D.DeptID=CR.DeptID
            JOIN tblINSTRUCTOR I ON I.InstructorID=IC.InstructorID
            JOIN tblINSTRUCTOR_INSTRUCTOR_TYPE IIT ON IIT.InstructorID=I.InstructorID
            JOIN tblINSTRUCTOR_TYPE IT ON IT.IntrustorTypeID=IIT.InstructorTypeID
            JOIN tblQUARTER Q ON Q.QuarterID=C.QuarterID
            WHERE IT.InstructorTypeName='Assistance' OR IT.InstructorTypeName='Associate'
            AND CR.CourseName LIKE '%4__'
            AND D.DeptName='Biology' OR D.DeptName='Philosophy'
            AND Q.QuarterID='Summer')
    SET @Ret = 1
RETURN @Ret
END 
GO

ALTER TABLE tblINSTRUCTOR
ADD CONSTRAINT CK_noBioPhil
CHECK (dbo.fn_noBioPhil()=0)

--17.	Create check constraint to restrict students assigned to dorm rooms on West Campus to be 
--at least 20 years old.

CREATE FUNCTION fn_noUnderThan20Dorm()
RETURNS INT
AS 
BEGIN
DECLARE @Ret INT = 0
IF EXISTS(SELECT * FROM tblSTUDENT S
            JOIN tblSTUDENT_DORMROOM SD ON SD.StudentID=S.StudentID
            JOIN tblDORMROOM D ON D.DormroomID=SD.DormroomID
            JOIN tblBUILDING B ON B.BuildingID=D.BuildingID
            JOIN tblLOCATION L ON L.LocationID=B.LocationID
            WHERE S.StudentDateOfBirth > (SELECT GetDate() - (365.25 * 20))
            AND L.LocationName='West Campus')
    SET @Ret = 1
RETURN @Ret
END
GO

ALTER TABLE tblSTUDENT
ADD CONSTRAIN CK_noUnderThan20Dorm
CHECK (dbo.fn_noUnderThan20Dorm()=0)



--18.	Write the query to create the following set of procedures:

--a.	Given the inputs of StudentFname, StudentLname and StudentDateOfBirth will return StudentID as an output parameter

CREATE PROCEDURE usp_studentID
@Fname varchar(100),
@Lname varchar(100),
@ID INT OUTPUT
AS
SET @ID = (SELECT StudentID FROM tblSTUDENT
            WHERE StudentFname=@Fname
            AND StudentLname=@Lname)
GO


--b.	Given the input of CourseName will return CourseID as an output parameter

CREATE PROCEDURE usp_courseID
@CourseName varchar(100),
@ID INT OUTPUT
AS
SET @ID = (SELECT CourseID FROM tblCOURSE WHERE CourseName=@CourseName)
GO


--c.	Given the input of QuarterName will return QuarterID as an output parameter

CREATE PROCEDURE usp_quarterID
@QuarterName varchar(100),
@ID INT OUTPUT
AS
SET @ID = (SELECT QuarterID FROM tblQUARTER WHERE QuarterName=@QuarterName)
GO


--d.	Given the inputs of CourseName, Year, Quarter and Section will return ClassID as an output 
--parameter (while leveraging nested stored procedures defined above)

CREATE PROCEDURE usp_classID
@CourseName varchar(50), 
@Year INT, 
@QuarterName varchar(50), 
@Section varchar(50),
@ID INT OUTPUT
AS
SET @ID = (SELECT ClassID FROM tblCLASS 
                        WHERE CourseName=@CourseName
                        AND YEAR=@Year
                        AND QuarterName=@QuarterName
                        AND Section=@Secion)
GO


--e.	Given the inputs of StudentFname, StudentLname, StudentDateOfBirth, CourseName, QuarterName, 
--Year and Section will INSERT a new row in tblCLASS_LIST in a single explicit transaction (while leveraging nested stored procedures defined above).
CREATE PROCEDURE usp_newClassList
@StudentFname varchar(100), 
@StudentLname varchar(100), 
@StudentDateOfBirth DATE, 
@CourseName varchar(100), 
@QuarterName varchar(100), 
@Year INT, 
@Section varchar(100),
@Grade FLOAT,
@RegistrationDate DATE
AS
DECLARE @StudentID INT = (SELECT StudentID FROM tblSTUDENT  
                            WHERE StudentFname=@StudentFname
                            AND StudentLname=@StudentLname
                            AND StudentDateOfBirth=@StudentDateOfBirth)
DECLARE @CourseID INT = (SELECT CourseID FROM tblCOURSE WHERE CourseName=@CourseName)
DECLARE @QuarterID INT = (SELECT QuarterID FROM tblQUARTER WHERE QuarterName=@QuarterName)
DECLARE @ClassID INT = (SELECT ClassID FROM tblCLASS 
                            WHERE CourseID=@CourseID
                            AND QuarterID=@QuarterID
                            AND YEAR=@Year
                            AND Section=@Section)
BEGIN TRAN t1
INSERT INTO tblCLASS_LIST(StudentID, ClassID, Grade, RegistrationDate)
VALUES (@StudentID, @ClassID, @Grade, @RegistrationDate)
GO

IF @@ERROR <> 0 
    ROLLBACK TRAN t1
ELSE 
    COMMIT TRAN t1
GO

EXEC usp_newClassList
@StudentFname 'Rio', 
@StudentLname 'Ishii', 
@StudentDateOfBirth '1998-04-09', 
@CourseName 'INFO340', 
@QuarterName 'Spring', 
@Year 2018, 
@Section varchar 'AE',
@Grade 4.0,
@RegistrationDate '2018-04-20'