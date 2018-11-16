--Write the code to create a computed column to measure the total number of tasks each employee has completed in the past 2.5 years
CREATE FUNCTION fn_totaltasks(@EmpID INT)
RETURNS INT
AS
BEGIN
DECLARE @Ret INT = (SELECT COUNT(TaskID) FROM tblTask T
                    JOIN tblCUST_JOB_TASK CBT ON CBT.TaskID=T.TaskID
                    JOIN tblEMPLOYEE_SKILL ES ON ES.EmpSkillID=CBT.EmpSkillID
                    JOIN tblEMPLOYEE E ON E.EmpID=ES.EmpID
                    WHERE E.EmpID=@EmpID
                    AND CBT.BeginDate > (SELECT GetDate() - (912.5)))
RETURN @Ret
END
GO

ALTER tblCUST_JOB_TASK 
ADD totaltasks
AS (dbo.fn_totaltasks(EmpID))

--Write the code to create a stored procedure to insert a new row into EMPLOYEE_POSITION
CREATE PROCEDURE usp_newEmpPosition
@PositionName varchar(100),
@EmpFname varchar(100),
@EmpLname varchar(100),
@EmoBirthDate DATE,
@BeginDate DATE,
@EndDate DATE
AS 
DECLARE @PositionID INT = (SELECT PositionID FROM tblPOSITION WHERE PositionName=@PositionName)
DECLARE @EMPLOYEEID INT = (SELECT EMPLOYEEID FROM tblEMPLOYEE 
                            WHERE EmpFname=@EmpFname
                            AND EmpLname=@EmpLname
                            AND EmpBirthDate=@EmpBirthDate)
BEGIN TRAN t1
INSERT INTO tblEMPLOYEE_POSITION(EmpID, PositionID, BeginDate, EndDate)
VALUES (@EmpID, @PositionID, @BeginDate, @EndDate)

IF @@ERROR <> 0
    ROLLBACK TRAN t1
ELSE 
    COMMIT TRAN t1

--Write the code to determine which customers have placed more than 6 orders for any kind of flooring in the past 3 years
--who have also had a sliding-glassdoor replaced in the past 2 years with employee 'Jordan Beiley' have participated
SELECT C.CustID, C.CustFname, C.CustLname FROM tbl CUSTOMER C
    JOIN tblJOB J ON J.CustID=C.CustID
    JOIN tblORDER O ON O.JobID=J.JobID
    JOIN tblLINE_ITEM LI ON LI.OrderID=O.OrderID
    JOIN tblPRODUCT P ON P.ProductID=LI.ProductID
    JOIN tblPRODUCT_TYPE PT ON PT.ProductTypeID=P.ProductTypeID
WHERE PT.ProductTypeName = 'Flooring'
AND O.OrderDate > (SELECT GetDate() - (365.25 * 3))
AND C.CustID IN (SELECT C.CustID FROM tblEMPLOYEE E
                    JOIN EMPLOYEE_SKILL ES ON ES.EmployeeID = ES.EmployeeID
                    JOIN CUST_JOB_TASK CJT ON ES.EmpSkillID = CJT.EmpSkillID
                    JOIN JOB J ON CJT.JobID = J.JobID
                    JOIN CUSTOMER C ON C.CustID=J.CustID
                    JOIN [ORDER] O ON J.JobID = O.JobID
                    JOIN LINE_ITEM LI ON O.OrderID = LI.OrderID
                    JOIN PRODUCT P ON LI.ProductID = P.ProductID
                    JOIN PRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
                WHERE E.EmpFname = 'Jordan'
                AND E.EmpLname = 'Bailey'
                AND O.OrderDate > (SELECT GetDate() - (365.25 * 2))
                AND PT.ProductTypeName = 'Sliding Glass Door')
GROUP BY C.CustID, C.CustFname, C.CustLname
HAVING COUNT(*) >= 6

--Write the code to enforce the business rule that employees younger than 21 cannot participate in tasks with any tool type
--'Land Mauler'
CREATE FUNCTION fn_nolandmauler()
RETURNS INT
AS 
BEGIN
DECLARE @Ret INT = 0
IF EXISTS(SELECT * FROM tblTOOL_TYPE TT 
            JOIN tblTOOL T ON T.ToolTypeID=TT.ToolTypeID
            JOIN tblCUST_JOB_TASK CJT ON CJT.ToolID=T.ToolID
            JOIN tblEMPLOYEE_SKILL ES ON ES.EmpSkillID=CJT.EmpSkillID
            JOIN tblEMPLOYEE E ON E.EmpID=ES.EmpID
        WHERE TT.ToolTypeName='Land Mauler'
        AND E.BirthDate > DATEADD(YEAR, -21, GETDATE()))
    SET @Ret = 1
RETURN @Ret
END 
GO

ALTER tblCUST_JOB_TASK
ADD CONSTRAINT CK_nolandmauler
CHECK (dbo.fn_nolandmauler()=0)
GO