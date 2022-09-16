/* Create the tables. */
DROP TABLE IF EXISTS dbo.TestTable;

CREATE TABLE dbo.TestTable (
    Id INT NOT NULL PRIMARY KEY,
    City NVARCHAR(120) NULL,
    DateCreated DATETIME2 NOT NULL,
    DateModified DATETIME2 NULL
);

/* Insert the data. */
INSERT INTO dbo.TestTable (
    Id,
    City,
    DateCreated,
    DateModified
) VALUES 
( 1, 'Stockport', '2021-01-01 14:28:23', '2021-01-01 14:45:10' ),
( 2, 'Manchester', '2021-05-07 10:31:12', NULL ),
( 3, 'Glasgow', '2021-07-14 08:48:31', NULL );