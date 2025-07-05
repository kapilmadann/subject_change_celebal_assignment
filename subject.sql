DROP TABLE IF EXISTS SubjectAllotments;
DROP TABLE IF EXISTS SubjectRequest;

CREATE TABLE SubjectAllotments (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20),
    Is_Valid BIT
);

CREATE TABLE SubjectRequest (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20)
);

INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid) VALUES
('159103036', 'PO1491', 1),     
('159103036', 'PO1492', 0),
('159103036', 'PO1493', 0),
('159103036', 'PO1494', 0),
('159103036', 'PO1495', 0);

INSERT INTO SubjectRequest (StudentId, SubjectId) VALUES
('159103036', 'PO1496');

CREATE PROCEDURE ProcessSubjectRequests
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StudentId VARCHAR(50);
    DECLARE @RequestedSubjectId VARCHAR(50);
    DECLARE @CurrentSubjectId VARCHAR(50);

    DECLARE request_cursor CURSOR FOR
    SELECT StudentId, SubjectId FROM SubjectRequest;

    OPEN request_cursor;
    FETCH NEXT FROM request_cursor INTO @StudentId, @RequestedSubjectId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentId = @StudentId)
        BEGIN
            -- Get current valid subject
            SELECT @CurrentSubjectId = SubjectId
            FROM SubjectAllotments
            WHERE StudentId = @StudentId AND Is_Valid = 1;

            IF @CurrentSubjectId <> @RequestedSubjectId
            BEGIN
                -- Invalidate the old subject
                UPDATE SubjectAllotments
                SET Is_Valid = 0
                WHERE StudentId = @StudentId AND Is_Valid = 1;

                INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid)
                VALUES (@StudentId, @RequestedSubjectId, 1);
            END
        END
        ELSE
        BEGIN
            INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid)
            VALUES (@StudentId, @RequestedSubjectId, 1);
        END

        FETCH NEXT FROM request_cursor INTO @StudentId, @RequestedSubjectId;
    END

    CLOSE request_cursor;
    DEALLOCATE request_cursor;
END;

EXEC ProcessSubjectRequests;

SELECT * FROM SubjectAllotments WHERE StudentId = '159103036';
