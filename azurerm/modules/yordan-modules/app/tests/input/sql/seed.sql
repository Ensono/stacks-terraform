/* Create the tables. */
DROP TABLE IF EXISTS dbo.TestTable;

CREATE TABLE dbo.TestTable (
    Id INT NOT NULL PRIMARY KEY,
    firstName NVARCHAR(120) NULL,
    lastName NVARCHAR(120) NULL,
    DateCreated DATETIME NOT NULL
);

/* Insert the data. */
INSERT INTO dbo.TestTable (
    Id,
    firstName,
    lastName,
    DateCreated
) VALUES 
( 1, 'Francesco', 'Calvino', '2022-01-01 14:45:10' ),
( 2, 'Jack', 'Sheppard', '2021-01-01 14:45:10' ),
( 3, 'Barak', 'Obama', '2020-01-01 14:45:10' );