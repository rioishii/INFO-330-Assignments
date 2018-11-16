--Write the code to determine the quarter that had the most 300-level classes for departments in the college of 
--Arts and Sciences between 1968 and 1984 that also had at least 200 total classes in 'the quad' between 1958 and 1962.

SELECT TOP 1 Q.QuarterName, Count(C.ClassID) AS NumCourses FROM tblQUARTER Q
    JOIN tblCLASS C ON C.QuarterID=Q.QuarterID
    JOIN tblCOURSE CR ON CR.CourseID=C.CourseID
    JOIN tblDEPARTMENT D ON D.DeptID=CR.DeptID
    JOIN tblCOLLEGE CL ON CL.CollegeID=D.CollegeID
WHERE CR.CourseName LIKE '%3__'
    AND C.YEAR BETWEEN 1968 AND 1984
    AND CL.CollegeName='Arts and Sciences'
    AND D.DeptName IN (SELECT D.DeptName FROM tblDEPARTMENT D
        JOIN tblCOURSE CRS ON CRS.DeptID=D.DeptID
        JOIN tblCLASS C ON C.CourseID=CRS.CourseID
        JOIN tblCLASSROOM CR ON CR.ClassroomID=C.ClassroomID
        JOIN tblBUILDING B ON B.BuildingID=CR.BuildingID
        JOIN tblLOCATION L ON L.LocationID=B.LocationID
    WHERE L.LocationName='Liberal Arts Quadrangle (''The Quad'')'
    AND C.YEAR BETWEEN 1958 AND 1962
    GROUP BY D.DeptName
    HAVING COUNT(*) >= 200)
GROUP BY Q.QuarterName
ORDER BY NumCourses DESC

--Write the code to determine the students that had at least 2 relationships listed as 'sibling' in addition 
--to having completed 20 credits of 300-level chemistry after 2011.

SELECT S.StudentID, COUNT(R.RelationshipID) AS NumRelationships FROM tblSTUDENT S
    INNER JOIN tblSTUDENT_CONTACT SC ON SC.StudentID=S.StudentID
    INNER JOIN tblRELATIONSHIP R ON R.RelationshipID=SC.RelationshipID
WHERE R.RelationshipName='Sibling'
    AND S.StudentID IN (SELECT S.StudentID FROM tblSTUDENT S 
        INNER JOIN tblCLASS_LIST CL ON CL.StudentID=S.StudentID
        INNER JOIN tblCLASS C ON C.ClassID=CL.ClassID
        INNER JOIN tblCOURSE CR ON CR.CourseID=C.CourseID
        INNER JOIN tblDEPARTMENT D ON D.DeptID=CR.DeptID
    WHERE CR.CourseName LIKE '%3__'
        AND D.DeptAbbrev='CHEM'
        AND C.YEAR > 2011
    GROUP BY S.StudentID
    HAVING SUM(CR.Credits) >= 20)
GROUP BY S.StudentID
HAVING COUNT(R.RelationshipID) >= 2

--Write the code to determine the most-common dorm room type for students who have special needs of either 'Physical Access' 
--or 'Preparation Accommodation' who completed a business school course before 1989 with a grade between 3.4 and 3.8

SELECT DT.DormRoomTypeName, COUNT(S.StudentID) AS Num FROM tblSPECIAL_NEED SN 
    INNER JOIN tblSTUDENT_SPECIAL_NEED SSN ON SSN.SpecialNeedID=SN.SpecialNeedID
    INNER JOIN tblStudent S ON S.StudentID=SSN.StudentID
    INNER JOIN tblSTUDENT_DORMROOM SD ON SD.StudentID=S.StudentID
    INNER JOIN tblDORMROOM DR ON DR.DormRoomID=SD.DormRoomID
    INNER JOIN tblDORMROOM_TYPE DT ON DT.DormRoomTypeID=DR.DormRoomTypeID
WHERE (SN.SpecialNeedName='Physical Access' OR SN.SpecialNeedName='Preparation Accommodation')
    AND S.StudentID IN (SELECT S.StudentID FROM tblSTUDENT S
        INNER JOIN tblCLASS_LIST CL ON CL.StudentID=S.StudentID
        INNER JOIN tblCLASS C ON C.ClassID=CL.ClassID
        INNER JOIN tblCOURSE CR ON CR.CourseID=C.CourseID
        INNER JOIN tblDEPARTMENT D ON D.DeptID=CR.DeptID
        INNER JOIN tblCOLLEGE CG ON CG.CollegeID=D.CollegeID
    WHERE C.YEAR < 1989
        AND CG.CollegeName = 'Business (Foster)'
        AND CL.Grade BETWEEN 3.4 AND 3.8)
GROUP BY DT.DormRoomTypeName
ORDER BY Num DESC