IF DB_ID('JOB_LIST_DB') IS NULL
	CREATE DATABASE JOB_LIST_DB;
GO

USE JOB_LIST_DB;
GO

IF OBJECT_ID(N'dbo.ROLES', N'U') IS NULL
  CREATE TABLE ROLES(
	ID INT NOT NULL,
	[NAME] VARCHAR (10) NOT NULL, 

	CONSTRAINT PK_ROLES PRIMARY KEY (ID),
	CONSTRAINT UQ_ROLES_NAME UNIQUE ([NAME])
  );
GO


IF OBJECT_ID(N'dbo.LANGUAGES', N'U') IS NULL
	CREATE TABLE LANGUAGES(
		ID INT NOT NULL,
		[NAME] NVARCHAR (50) NOT NULL,
		
		CONSTRAINT PK_LANGUAGES PRIMARY KEY (ID),
		CONSTRAINT UQ_LANGUAGES_NAME UNIQUE ([NAME])
	);
GO


IF OBJECT_ID(N'dbo.SCHOOLS', N'U') IS NULL
BEGIN
	CREATE TABLE SCHOOLS(
		ID INT NOT NULL,
		[NAME] VARCHAR (300) NOT NULL,

		CONSTRAINT PK_SCHOOLS PRIMARY KEY (ID),
		CONSTRAINT UQ_SCHOOLS_NAME UNIQUE ([NAME])
	);
END
GO

IF OBJECT_ID(N'dbo.WORK_AREAS', N'U') IS NULL
	CREATE TABLE WORK_AREAS(
		ID INT IDENTITY (1, 1) NOT NULL, 
		[NAME] VARCHAR(100) NOT NULL,

		CONSTRAINT PK_WORK_AREAS PRIMARY KEY (ID),
		CONSTRAINT UQ_WORK_AREAS_NAME UNIQUE ([NAME])
	);
GO


IF OBJECT_ID(N'dbo.FACULTIES', N'U') IS NULL
	CREATE TABLE FACULTIES(
		ID INT NOT NULL,
		[NAME] VARCHAR (200) NOT NULL,

		CONSTRAINT PK_FACULTIES PRIMARY KEY (ID),
		CONSTRAINT UQ_FACULTIES_NAME UNIQUE ([NAME])
	);
GO



IF OBJECT_ID(N'dbo.CITIES', N'U') IS NULL
	CREATE TABLE CITIES(
		ID INT NOT NULL,
		[NAME] VARCHAR (100) NOT NULL,

		CONSTRAINT PK_CITIES PRIMARY KEY (ID),
		CONSTRAINT UQ_CITIES_NAME UNIQUE ([NAME])
	);
GO



IF OBJECT_ID(N'dbo.COMPANIES', N'U') IS NULL
	CREATE TABLE COMPANIES(
		ID INT IDENTITY (1, 1) NOT NULL, 
		[NAME] VARCHAR (200) NOT NULL, 
		BOSS_NAME VARCHAR (100) NOT NULL,
		FULL_DESCRIPTION VARCHAR (MAX) NOT NULL,
		SHORT_DESCRIPTION VARCHAR (25) NOT NULL,
		[ADDRESS] VARCHAR (200) NOT NULL,
		PHONE VARCHAR (15) NULL,
		LOGO_DATA VARCHAR (MAX) NULL,
		LOGO_MIMETYPE VARCHAR (5) NULL,
		[SITE] VARCHAR (100) NULL,
		EMAIL VARCHAR (254) NOT NULL,
		[PASSWORD] VARCHAR (100) NOT NULL,
		ROLE_ID INT NOT NULL,

		CONSTRAINT PK_COMPANIES PRIMARY KEY (ID),
		CONSTRAINT FK_COMPANIES_TO_ROLES FOREIGN KEY (ROLE_ID) REFERENCES ROLES(ID),
		
		CONSTRAINT UQ_COMPANIES_NAME UNIQUE ([NAME]),
		CONSTRAINT UQ_COMPANIES_PHONE UNIQUE ([PHONE]),
		CONSTRAINT UQ_COMPANIES_EMAIL UNIQUE ([EMAIL])
	);
GO


IF OBJECT_ID(N'dbo.RECRUITERS', N'U') IS NULL
	CREATE TABLE RECRUITERS(
		ID INT IDENTITY (1, 1) NOT NULL, 
		FIRST_NAME VARCHAR (50) NOT NULL, 
		LAST_NAME VARCHAR (50) NOT NULL,
		PHOTO_DATA VARCHAR (MAX) NULL,
		PHOTO_MIME_TYPE VARCHAR (5) NULL,
		PHONE VARCHAR (15) NULL,
		EMAIL VARCHAR (254) NOT NULL,
		[PASSWORD] VARCHAR (100) NOT NULL,
		COMPANY_ID INT NOT NULL,
		ROLE_ID INT NOT NULL,

		CONSTRAINT PK_RECRUITERS PRIMARY KEY (ID),
		CONSTRAINT FK_RECRUITERS_TO_COMPANIES FOREIGN KEY (COMPANY_ID) REFERENCES COMPANIES (ID) ON DELETE CASCADE,
		CONSTRAINT FK_RECRUITERS_TO_ROLES FOREIGN KEY (ROLE_ID) REFERENCES ROLES (ID),

		CONSTRAINT UQ_RECRUITERS_EMAIL UNIQUE ([EMAIL]),
		CONSTRAINT UQ_RECRUITERS_PHONE UNIQUE ([PHONE])
	);
GO


IF OBJECT_ID(N'dbo.VACANCIES', N'U') IS NULL
	CREATE TABLE VACANCIES(
		ID INT IDENTITY (1, 1) NOT NULL, 
		[NAME] VARCHAR (200) NOT NULL, 
		[DESCRIPTION] VARCHAR (MAX) NOT NULL,
		OFFERING VARCHAR (MAX) NOT NULL,
		REQUIREMENTS VARCHAR (MAX) NOT NULL,
		BE_PLUS VARCHAR (MAX) NULL,
		IS_CHECKED BIT NULL,
		SALARY MONEY NULL,
		FULL_PART_TIME VARCHAR (25),
		CREATE_DATE DATETIME NOT NULL DEFAULT GETDATE(),
		MOD_DATE DATETIME NULL DEFAULT GETDATE(),
		RECRUITER_ID INT NOT NULL,
		CITY_ID INT NOT NULL,
		WORK_AREA_ID INT NOT NULL,

		CONSTRAINT PK_VACANCIES PRIMARY KEY (ID),
		CONSTRAINT FK_VACANCIES_TO_RECRUITERS FOREIGN KEY (RECRUITER_ID) REFERENCES RECRUITERS (ID) ON DELETE CASCADE,
		CONSTRAINT FK_VACANCIES_TO_CITIES FOREIGN KEY (CITY_ID) REFERENCES CITIES (ID),
		CONSTRAINT FK_VACANCIES_TO_WORK_AREAS FOREIGN KEY (WORK_AREA_ID) REFERENCES WORK_AREAS (ID)
	);
GO

IF OBJECT_ID(N'TU_VACANCIES', N'TR') IS NOT NULL
	DROP TRIGGER TU_VACANCIES
GO

CREATE TRIGGER TU_VACANCIES ON VACANCIES
AFTER UPDATE
AS
	IF NOT EXISTS (SELECT * FROM INSERTED) OR (TRIGGER_NESTLEVEL()>1)
	RETURN

	UPDATE VACANCIES
	SET VACANCIES.MOD_DATE = GETDATE()
	WHERE VACANCIES.ID IN (SELECT ID FROM INSERTED)
GO

IF OBJECT_ID(N'dbo.EMPLOYEES', N'U') IS NULL
	CREATE TABLE EMPLOYEES(
		ID INT IDENTITY (1, 1) NOT NULL, 
		FIRST_NAME VARCHAR (50) NOT NULL, 
		LAST_NAME VARCHAR (50) NOT NULL,
		PHONE VARCHAR (15) NULL,
		PHOTO_DATA VARCHAR (MAX) NULL,
		PHOTO_MIME_TYPE VARCHAR (5) NULL,
		SEX CHAR (1) NULL,
		BIRTH_DATA DATE NOT NULL,
		EMAIL VARCHAR (254) NOT NULL,
		[PASSWORD] VARCHAR (100) NOT NULL,
		ROLE_ID INT NOT NULL,
		CITY_ID INT NOT NULL,

		CONSTRAINT PK_EMPLOYEES PRIMARY KEY (ID),
		CONSTRAINT FK_EMPLOYEES_TO_CITIES FOREIGN KEY (CITY_ID) REFERENCES CITIES (ID),
		CONSTRAINT FK_EMPLOYEES_TO_ROLES FOREIGN KEY (ROLE_ID) REFERENCES ROLES (ID),

		CONSTRAINT UQ_EMPLOYEES_EMAIL UNIQUE ([EMAIL]),
		CONSTRAINT UQ_EMPLOYEES_PHONE UNIQUE ([PHONE]),

		CONSTRAINT CHK_EMPLOYEES_SEX CHECK (SEX='M' OR SEX='F')
	);
GO


IF OBJECT_ID(N'dbo.RESUMES', N'U') IS NULL
	CREATE TABLE RESUMES(
		ID INT NOT NULL, 
		LINKEDIN VARCHAR (200) NULL,
		GITHUB VARCHAR (200) NULL,
		FACEBOOK VARCHAR (200) NULL,
		SKYPE VARCHAR (200) NULL,
		INSTAGRAM VARCHAR (200) NULL,
		INTRODUCTION VARCHAR (300) NOT NULL,
		POSITION VARCHAR (100) NULL,
		FAMILY_STATE VARCHAR (20) NULL,
		SOFT_SKILLS VARCHAR (MAX) NOT  NULL,
		KEY_SKILLS VARCHAR (MAX) NOT NULL,
		COURSES VARCHAR (MAX) NULL,
		CREATE_DATE DATETIME NOT NULL DEFAULT GETDATE (),
		MOD_DATE DATETIME NULL DEFAULT GETDATE (),
		WORK_AREA_ID INT NOT NULL,

		CONSTRAINT PK_RESUMES PRIMARY KEY (ID),
		CONSTRAINT FK_RESUMES_TO_EMPLOYEES FOREIGN KEY (ID) REFERENCES EMPLOYEES (ID) ON DELETE CASCADE,
		CONSTRAINT FK_RESUMES_TO_WORKAREA FOREIGN KEY (WORK_AREA_ID) REFERENCES WORK_AREAS (ID),


		CONSTRAINT UQ_RESUMES_LINKEDIN UNIQUE (LINKEDIN),
		CONSTRAINT UQ_RESUMES_FACEBOOK UNIQUE (FACEBOOK),
		CONSTRAINT UQ_RESUMES_SKYPE UNIQUE (SKYPE),
		CONSTRAINT UQ_RESUMES_INSTAGRAM UNIQUE (INSTAGRAM)
	);
GO

IF OBJECT_ID(N'TU_RESUMES', N'TR') IS NOT NULL
	DROP TRIGGER TU_RESUMES
GO

CREATE TRIGGER TU_RESUMES ON RESUMES
AFTER UPDATE
AS
	IF NOT EXISTS (SELECT * FROM INSERTED) OR (TRIGGER_NESTLEVEL()>1)
	RETURN

	UPDATE RESUMES
	SET RESUMES.MOD_DATE = GETDATE()
	WHERE RESUMES.ID IN (SELECT ID FROM INSERTED)
GO

IF OBJECT_ID(N'dbo.EXPERIENCES', N'U') IS NULL
	CREATE TABLE EXPERIENCES(
		ID INT IDENTITY (1, 1) NOT NULL, 
		COMPANY_NAME VARCHAR(200) NOT NULL,
		POSITION VARCHAR(200) NOT NULL,
		[START_DATE] DATE NOT NULL,
		FINISH_DATE DATE NULL,
		RESUME_ID INT NOT NULL,

		CONSTRAINT PK_EXPERIENCES PRIMARY KEY (ID),
		CONSTRAINT FK_EXPERIENCES_TO_RESUMES FOREIGN KEY (RESUME_ID) REFERENCES RESUMES (ID) ON DELETE CASCADE
	);
GO

IF OBJECT_ID(N'dbo.EDUCATION_PERIODS', N'U') IS NULL
	CREATE TABLE EDUCATION_PERIODS(
		ID INT IDENTITY (1, 1) NOT NULL, 
		[START_DATE] DATE NOT NULL,
		[FINISH_DATE] DATE NOT NULL,
		SCHOOL_ID INT NOT NULL,
		RESUME_ID INT NOT NULL,

		CONSTRAINT PK_EDUCATION_PERIODS PRIMARY KEY (ID),
		CONSTRAINT FK_PK_EDUCATION_PERIODS_TO_SCHOOLS FOREIGN KEY (SCHOOL_ID) REFERENCES SCHOOLS (ID),
		CONSTRAINT FK_PK_EDUCATION_PERIODS_TO_RESUMES FOREIGN KEY (RESUME_ID) REFERENCES RESUMES (ID) ON DELETE CASCADE
	);
GO

IF OBJECT_ID(N'dbo.RESUME_LANGUAGES', N'U') IS NULL
	CREATE TABLE RESUME_LANGUAGES(
		ID INT IDENTITY (1, 1) NOT NULL, 
		RESUME_ID INT NOT NULL,
		LANGUAGE_ID INT NOT NULL,

		CONSTRAINT PK_RESUME_LANGUAGES PRIMARY KEY (ID),
		CONSTRAINT FK_PK_RESUME_LANGUAGES_TO_LANGUAGES FOREIGN KEY (LANGUAGE_ID) REFERENCES LANGUAGES (ID),
		CONSTRAINT FK_PK_RESUME_LANGUAGES_TO_RESUMES FOREIGN KEY (RESUME_ID) REFERENCES RESUMES (ID) ON DELETE CASCADE
	);
GO

IF OBJECT_ID(N'dbo.FAVORITE_VACANCIES', N'U') IS NULL
	CREATE TABLE FAVORITE_VACANCIES(
		ID INT IDENTITY (1, 1) NOT NULL, 
		VACANCY_ID INT NOT NULL,
		[EMPLOYEE_ID] INT NOT NULL,

		CONSTRAINT PK_FAVORITE_VACANCIES PRIMARY KEY (ID),
		CONSTRAINT FK_FAVORITE_VACANCIES_TO_VACANCIES FOREIGN KEY (VACANCY_ID) REFERENCES VACANCIES (ID) ON DELETE CASCADE,
		CONSTRAINT FK_FAVORITE_VACANCIES_TO_EMPLOYEES FOREIGN KEY ([EMPLOYEE_ID]) REFERENCES EMPLOYEES (ID) ON DELETE CASCADE
	);
GO

IF OBJECT_ID(N'dbo.INVITATIONS', N'U') IS NULL
	CREATE TABLE INVITATIONS(
		ID INT IDENTITY (1, 1) NOT NULL, 
		VACANCY_ID INT NOT NULL,
		[EMPLOYEE_ID] INT NOT NULL,

		CONSTRAINT PK_INVITATIONS PRIMARY KEY (ID),
		CONSTRAINT FK_INVITATIONS_TO_VACANCIES FOREIGN KEY (VACANCY_ID) REFERENCES VACANCIES (ID) ON DELETE CASCADE,
		CONSTRAINT FK_INVITATIONS_TO_EMPLOYEES FOREIGN KEY ([EMPLOYEE_ID]) REFERENCES EMPLOYEES (ID) ON DELETE CASCADE
	);
GO