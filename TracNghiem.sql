USE [THI_TN]
GO
/****** Object:  User [HTKN]    Script Date: 6/27/2024 11:32:38 AM ******/
CREATE USER [HTKN] FOR LOGIN [HTKN] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [MSmerge_AB5ED753F7554C588CFD3C7AD6C97852]    Script Date: 6/27/2024 11:32:38 AM ******/
CREATE ROLE [MSmerge_AB5ED753F7554C588CFD3C7AD6C97852]
GO
/****** Object:  DatabaseRole [MSmerge_AC88758D01334529B199AA8CDB89F062]    Script Date: 6/27/2024 11:32:38 AM ******/
CREATE ROLE [MSmerge_AC88758D01334529B199AA8CDB89F062]
GO
/****** Object:  DatabaseRole [MSmerge_FFCEDB074BB8453F895A5BFD6AD612E2]    Script Date: 6/27/2024 11:32:38 AM ******/
CREATE ROLE [MSmerge_FFCEDB074BB8453F895A5BFD6AD612E2]
GO
/****** Object:  DatabaseRole [MSmerge_PAL_role]    Script Date: 6/27/2024 11:32:38 AM ******/
CREATE ROLE [MSmerge_PAL_role]
GO
ALTER ROLE [db_owner] ADD MEMBER [HTKN]
GO
ALTER ROLE [MSmerge_PAL_role] ADD MEMBER [MSmerge_AB5ED753F7554C588CFD3C7AD6C97852]
GO
ALTER ROLE [MSmerge_PAL_role] ADD MEMBER [MSmerge_AC88758D01334529B199AA8CDB89F062]
GO
ALTER ROLE [MSmerge_PAL_role] ADD MEMBER [MSmerge_FFCEDB074BB8453F895A5BFD6AD612E2]
GO
/****** Object:  Schema [MSmerge_PAL_role]    Script Date: 6/27/2024 11:32:39 AM ******/
CREATE SCHEMA [MSmerge_PAL_role]
GO
/****** Object:  UserDefinedTableType [dbo].[BAITHI]    Script Date: 6/27/2024 11:32:39 AM ******/
CREATE TYPE [dbo].[BAITHI] AS TABLE(
	[CAUHOI] [int] NULL,
	[DACHON] [char](1) NULL,
	[CAUSO] [int] NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[checkMH]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[checkMH](@maMH nchar(5))
RETURNS VARCHAR(50) 
AS
BEGIN
DECLARE @checked VARCHAR(50);
DECLARE  @len INT = 0;

 SELECT @len = COUNT(*) FROM BANGDIEM WHERE BANGDIEM.DIEM IS NOT NULL AND BANGDIEM.MAMH=@maMH;

IF @len > 0
 SET @checked = 'X';
 ELSE
 SET @checked = '';

RETURN @checked;

END;
GO
/****** Object:  UserDefinedFunction [dbo].[ConcatValuesWithPeriodAndNewLine]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ConcatValuesWithPeriodAndNewLine]
(
    @A VARCHAR(MAX),
    @B VARCHAR(MAX),
    @C VARCHAR(MAX),
    @D VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @Result VARCHAR(MAX)
    SET @Result = CONCAT('A. ',@A, CHAR(13),'B. ', @B, '.', CHAR(13), 'C. ',@C, '.', CHAR(13),'D. ', @D, '.')
    RETURN @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[FloatToText]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FloatToText] (@number FLOAT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @integerPart INT;
    DECLARE @decimalPart INT;
    DECLARE @result NVARCHAR(100);

    -- Extract integer and decimal parts
    SET @integerPart = CAST(@number AS INT);
    SET @decimalPart = ROUND((@number - @integerPart) * 10, 0);

    -- Convert integer part to words
    IF @integerPart = 10 
        SET @result = N'Mười'
    ELSE
        SET @result = 
            CASE 
                WHEN @integerPart = 0 THEN N'Không'
                WHEN @integerPart = 1 THEN N'Một'
                WHEN @integerPart = 2 THEN N'Hai'
                WHEN @integerPart = 3 THEN N'Ba'
                WHEN @integerPart = 4 THEN N'Bốn'
                WHEN @integerPart = 5 THEN N'Năm'
                WHEN @integerPart = 6 THEN N'Sáu'
                WHEN @integerPart = 7 THEN N'Bảy'
                WHEN @integerPart = 8 THEN N'Tám'
                WHEN @integerPart = 9 THEN N'Chín'
                ELSE ''
            END;

    -- Add 'dot' if there's a decimal part
    IF @decimalPart <> 0
    BEGIN
        SET @result = @result + N' phẩy ';
        
        -- Convert decimal part to words
        SET @result = @result +
            CASE 
                WHEN @decimalPart = 1 THEN N'một'
                WHEN @decimalPart = 2 THEN N'hai'
                WHEN @decimalPart = 3 THEN N'ba'
                WHEN @decimalPart = 4 THEN N'bốn'
                WHEN @decimalPart = 5 THEN N'năm'
                WHEN @decimalPart = 6 THEN N'sáu'
                WHEN @decimalPart = 7 THEN N'bảy'
                WHEN @decimalPart = 8 THEN N'tám'
                WHEN @decimalPart = 9 THEN N'chín'
                ELSE ''
            END;
    END;

    RETURN @result;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[FN_CheckDaThi]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_CheckDaThi] (
@MAMH NCHAR(8), 
@MALOP nchar(15), 
@LAN int)
RETURNS NCHAR(1)
AS
BEGIN
	IF EXISTS(SELECT * FROM dbo.BANGDIEM
	WHERE  LAN = @LAN AND MAMH = @MAMH AND MASV IN(SELECT MASV FROM SINHVIEN WHERE MALOP = @MALOP)) RETURN 'X'
	RETURN 'O'
END
GO
/****** Object:  Table [dbo].[KHOA]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHOA](
	[MAKH] [nchar](8) NOT NULL,
	[TENKH] [nvarchar](50) NOT NULL,
	[MACS] [nchar](3) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_KHOA] PRIMARY KEY CLUSTERED 
(
	[MAKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[GET_KHOA]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GET_KHOA]
AS
   SELECT MAKHOA=MAKH, TENKHOA=TENKH
   FROM dbo.KHOA
GO
/****** Object:  Table [dbo].[BANGDIEM]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BANGDIEM](
	[MASV] [char](8) NOT NULL,
	[MAMH] [char](5) NOT NULL,
	[LAN] [smallint] NOT NULL,
	[NGAYTHI] [datetime] NULL,
	[DIEM] [float] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_BANGDIEM] PRIMARY KEY CLUSTERED 
(
	[MASV] ASC,
	[MAMH] ASC,
	[LAN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOP]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOP](
	[MALOP] [nchar](15) NOT NULL,
	[TENLOP] [nvarchar](50) NOT NULL,
	[MAKH] [nchar](8) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_LOP] PRIMARY KEY CLUSTERED 
(
	[MALOP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UN_TENLOP] UNIQUE NONCLUSTERED 
(
	[TENLOP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SINHVIEN]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SINHVIEN](
	[MASV] [char](8) NOT NULL,
	[HO] [nvarchar](50) NULL,
	[TEN] [nvarchar](10) NULL,
	[NGAYSINH] [date] NULL,
	[DIACHI] [nvarchar](100) NULL,
	[MALOP] [nchar](15) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[PASSWORD] [nchar](15) NULL,
 CONSTRAINT [PK_SINHVIEN] PRIMARY KEY CLUSTERED 
(
	[MASV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[GET_LOP_CO_BANGDIEM]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[GET_LOP_CO_BANGDIEM]
AS
   SELECT LOP.MALOP, LOP.TENLOP
   FROM LOP JOIN SINHVIEN ON LOP.MALOP = SINHVIEN.MALOP 
   JOIN BANGDIEM ON SINHVIEN.MASV = BANGDIEM.MASV
GO
/****** Object:  View [dbo].[GET_Subscribes]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GET_Subscribes]
AS
   SELECT TENCOSO=PUBS.description, TENSERVER= subscriber_server
   FROM dbo.sysmergepublications PUBS,  dbo.sysmergesubscriptions SUBS
   WHERE PUBS.pubid= SUBS.PUBID  AND PUBS.publisher <> SUBS.subscriber_server AND PUBS.description != 'Server3'
GO
/****** Object:  Table [dbo].[BODE]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BODE](
	[CAUHOI] [int] NOT NULL,
	[MAMH] [char](5) NULL,
	[TRINHDO] [char](1) NULL,
	[NOIDUNG] [ntext] NULL,
	[A] [ntext] NULL,
	[B] [ntext] NULL,
	[C] [ntext] NULL,
	[D] [ntext] NULL,
	[DAP_AN] [char](1) NULL,
	[MAGV] [char](8) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_BODE] PRIMARY KEY CLUSTERED 
(
	[CAUHOI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[COSO]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COSO](
	[MACS] [nchar](3) NOT NULL,
	[TENCS] [nvarchar](50) NOT NULL,
	[DIACHI] [nvarchar](100) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_COSO] PRIMARY KEY CLUSTERED 
(
	[MACS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_BAITHI]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_BAITHI](
	[CAUHOI] [int] NOT NULL,
	[MASV] [char](8) NOT NULL,
	[MAMH] [char](5) NOT NULL,
	[LAN] [smallint] NOT NULL,
	[DACHON] [char](1) NULL,
	[CAUSO] [int] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CAUHOI] ASC,
	[LAN] ASC,
	[MAMH] ASC,
	[MASV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GIAOVIEN]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIAOVIEN](
	[MAGV] [char](8) NOT NULL,
	[HO] [nvarchar](50) NULL,
	[TEN] [nvarchar](10) NULL,
	[DIACHI] [nvarchar](50) NULL,
	[MAKH] [nchar](8) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_GIAOVIEN] PRIMARY KEY CLUSTERED 
(
	[MAGV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GIAOVIEN_DANGKY]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIAOVIEN_DANGKY](
	[MAGV] [char](8) NULL,
	[MAMH] [char](5) NOT NULL,
	[MALOP] [nchar](15) NOT NULL,
	[TRINHDO] [char](1) NULL,
	[NGAYTHI] [datetime] NULL,
	[LAN] [smallint] NOT NULL,
	[SOCAUTHI] [smallint] NULL,
	[THOIGIAN] [smallint] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_GIAOVIEN_DANGKY] PRIMARY KEY CLUSTERED 
(
	[MAMH] ASC,
	[MALOP] ASC,
	[LAN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MONHOC]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MONHOC](
	[MAMH] [char](5) NOT NULL,
	[TENMH] [nvarchar](50) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_TENMH] PRIMARY KEY CLUSTERED 
(
	[MAMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UN_TENMH] UNIQUE NONCLUSTERED 
(
	[TENMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BANGDIEM] ADD  CONSTRAINT [MSmerge_df_rowguid_B6C980EFD6B246489BBA6561A1F2F9EF]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[BODE] ADD  CONSTRAINT [MSmerge_df_rowguid_9BCAABD6A456457FA69FE6D8E9C74C66]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[COSO] ADD  CONSTRAINT [MSmerge_df_rowguid_98E9DB32F4044FF3A23CF10F57C5AAFA]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[CT_BAITHI] ADD  CONSTRAINT [MSmerge_df_rowguid_6FFC280B6B8040F1AA283A20A247E66F]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[GIAOVIEN] ADD  CONSTRAINT [MSmerge_df_rowguid_4131C7D6B3294FD5BF31F1DC0DCD71EA]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] ADD  CONSTRAINT [MSmerge_df_rowguid_B597EC7D9C7F4C6B9FF08C229F78795F]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[KHOA] ADD  CONSTRAINT [MSmerge_df_rowguid_031B9CE986A54DBDB9981BC8255AD415]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[LOP] ADD  CONSTRAINT [MSmerge_df_rowguid_2B10DFD45BB842A888D5FBAB0866C521]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[MONHOC] ADD  CONSTRAINT [MSmerge_df_rowguid_EEFBB85E63DF4E55A1DA1A1048B402CB]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[SINHVIEN] ADD  CONSTRAINT [MSmerge_df_rowguid_BF93140991D2423F85BCB1DCD81E10AA]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[BANGDIEM]  WITH NOCHECK ADD  CONSTRAINT [FK_BANGDIEM_MONHOC] FOREIGN KEY([MAMH])
REFERENCES [dbo].[MONHOC] ([MAMH])
GO
ALTER TABLE [dbo].[BANGDIEM] CHECK CONSTRAINT [FK_BANGDIEM_MONHOC]
GO
ALTER TABLE [dbo].[BANGDIEM]  WITH NOCHECK ADD  CONSTRAINT [FK_BANGDIEM_SINHVIEN1] FOREIGN KEY([MASV])
REFERENCES [dbo].[SINHVIEN] ([MASV])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[BANGDIEM] CHECK CONSTRAINT [FK_BANGDIEM_SINHVIEN1]
GO
ALTER TABLE [dbo].[BODE]  WITH NOCHECK ADD  CONSTRAINT [FK_BODE_GIAOVIEN] FOREIGN KEY([MAGV])
REFERENCES [dbo].[GIAOVIEN] ([MAGV])
GO
ALTER TABLE [dbo].[BODE] CHECK CONSTRAINT [FK_BODE_GIAOVIEN]
GO
ALTER TABLE [dbo].[BODE]  WITH NOCHECK ADD  CONSTRAINT [FK_BODE_MONHOC] FOREIGN KEY([MAMH])
REFERENCES [dbo].[MONHOC] ([MAMH])
GO
ALTER TABLE [dbo].[BODE] CHECK CONSTRAINT [FK_BODE_MONHOC]
GO
ALTER TABLE [dbo].[CT_BAITHI]  WITH CHECK ADD FOREIGN KEY([MASV], [MAMH], [LAN])
REFERENCES [dbo].[BANGDIEM] ([MASV], [MAMH], [LAN])
GO
ALTER TABLE [dbo].[CT_BAITHI]  WITH CHECK ADD FOREIGN KEY([CAUHOI])
REFERENCES [dbo].[BODE] ([CAUHOI])
GO
ALTER TABLE [dbo].[GIAOVIEN]  WITH CHECK ADD  CONSTRAINT [FK_GIAOVIEN_KHOA] FOREIGN KEY([MAKH])
REFERENCES [dbo].[KHOA] ([MAKH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GIAOVIEN] CHECK CONSTRAINT [FK_GIAOVIEN_KHOA]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [FK_GIAOVIEN_DANGKY_GIAOVIEN1] FOREIGN KEY([MAGV])
REFERENCES [dbo].[GIAOVIEN] ([MAGV])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [FK_GIAOVIEN_DANGKY_GIAOVIEN1]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [FK_GIAOVIEN_DANGKY_LOP] FOREIGN KEY([MALOP])
REFERENCES [dbo].[LOP] ([MALOP])
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [FK_GIAOVIEN_DANGKY_LOP]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [FK_GIAOVIEN_DANGKY_MONHOC1] FOREIGN KEY([MAMH])
REFERENCES [dbo].[MONHOC] ([MAMH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [FK_GIAOVIEN_DANGKY_MONHOC1]
GO
ALTER TABLE [dbo].[KHOA]  WITH CHECK ADD  CONSTRAINT [FK_KHOA_COSO] FOREIGN KEY([MACS])
REFERENCES [dbo].[COSO] ([MACS])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[KHOA] CHECK CONSTRAINT [FK_KHOA_COSO]
GO
ALTER TABLE [dbo].[LOP]  WITH CHECK ADD  CONSTRAINT [FK_LOP_KHOA] FOREIGN KEY([MAKH])
REFERENCES [dbo].[KHOA] ([MAKH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[LOP] CHECK CONSTRAINT [FK_LOP_KHOA]
GO
ALTER TABLE [dbo].[SINHVIEN]  WITH CHECK ADD  CONSTRAINT [FK_SINHVIEN_LOP] FOREIGN KEY([MALOP])
REFERENCES [dbo].[LOP] ([MALOP])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SINHVIEN] CHECK CONSTRAINT [FK_SINHVIEN_LOP]
GO
ALTER TABLE [dbo].[BANGDIEM]  WITH NOCHECK ADD  CONSTRAINT [CK_DIEM] CHECK  (([DIEM]>=(0) AND [DIEM]<=(10)))
GO
ALTER TABLE [dbo].[BANGDIEM] CHECK CONSTRAINT [CK_DIEM]
GO
ALTER TABLE [dbo].[BANGDIEM]  WITH NOCHECK ADD  CONSTRAINT [CK_LANTHI] CHECK  (([LAN]>=(1) AND [LAN]<=(2)))
GO
ALTER TABLE [dbo].[BANGDIEM] CHECK CONSTRAINT [CK_LANTHI]
GO
ALTER TABLE [dbo].[BODE]  WITH NOCHECK ADD  CONSTRAINT [CK_BODE] CHECK  (([TRINHDO]='A' OR [TRINHDO]='B' OR [TRINHDO]='C'))
GO
ALTER TABLE [dbo].[BODE] CHECK CONSTRAINT [CK_BODE]
GO
ALTER TABLE [dbo].[BODE]  WITH NOCHECK ADD  CONSTRAINT [CK_DAPAN] CHECK  (([DAP_AN]='D' OR ([DAP_AN]='C' OR ([DAP_AN]='B' OR [DAP_AN]='A'))))
GO
ALTER TABLE [dbo].[BODE] CHECK CONSTRAINT [CK_DAPAN]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [CK_LAN] CHECK  (([LAN]>=(1) AND [LAN]<=(2)))
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [CK_LAN]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [CK_SOCAUTHI] CHECK  (([SOCAUTHI]>=(10) AND [SOCAUTHI]<=(100)))
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [CK_SOCAUTHI]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [CK_THOIGIAN] CHECK  (([THOIGIAN]>=(15) AND [THOIGIAN]<=(60)))
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [CK_THOIGIAN]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [CK_TRINHDO] CHECK  (([TRINHDO]='C' OR ([TRINHDO]='B' OR [TRINHDO]='A')))
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [CK_TRINHDO]
GO
/****** Object:  StoredProcedure [dbo].[SP_CBT_CAN_DELETE]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CBT_CAN_DELETE]
@malop VARCHAR(16),
@mamh nchar(9),
@lan int
AS
BEGIN
	IF EXISTS(SELECT * FROM DBO.BANGDIEM 
		WHERE MAMH = @MAMH AND LAN = @lan AND MASV IN(SELECT MASV FROM SINHVIEN WHERE MALOP = @malop))
		RETURN -1
	ELSE 
		RETURN 1
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CBT_CHECKCOUNT_DETHI]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CBT_CHECKCOUNT_DETHI]
    @mamh nchar(9),
    @socauthi int,
    @trinhdo nchar(2)
	
AS

BEGIN
	DECLARE @trinhDo2 Nchar(1) = 'N'
	DECLARE @countQuestion int = 0
	DECLARE @countQuestionCungTrinhDo int = 0
	DECLARE @countQuestionTrinhDoDuoi int = 0
	DECLARE @message nchar(50)
	IF @trinhdo = 'A' 
		SET @trinhdo2 = 'B'
	ELSE IF @trinhdo = 'B'
		SET @trinhdo2 = 'C'

	set @countQuestionCungTrinhDo = (select count(*) from BODE where (MAMH = @mamh and TRINHDO = @trinhdo))
	set @countQuestionTrinhDoDuoi = (select count(*) from BODE where (MAMH = @mamh and TRINHDO = @trinhDo2))
	set @countQuestion = @countQuestionCungTrinhDo+@countQuestionTrinhDoDuoi
	if(@countQuestion < @socauthi or @countQuestionCungTrinhDo<(@socauthi*70.0/100))
		if @countQuestion < @socauthi
			begin
				SET @message = N'Thiếu ' + CAST(@socauthi-@countQuestion  AS NVARCHAR(10)) + N' câu';
				RAISERROR(@message,16,1)
			end
		else if @countQuestionCungTrinhDo<(@socauthi*70.0/100)
			begin
				SET @message = N'Thiếu ' + CAST(@socauthi*70.0/100-@socauthi  AS NVARCHAR(10)) + N' câu trình độ ' + @trinhdo;
				RAISERROR(@message,16,1)
			end
	else 
		return 1
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CBT_CHECKEXIST]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CBT_CHECKEXIST]
@malop VARCHAR(16),
@mamh nchar(9),
@lan int,
@ngaythi VARCHAR(10)
AS
BEGIN
	IF EXISTS(SELECT * FROM DBO.GIAOVIEN_DANGKY WHERE MAMH = @MAMH AND MALOP = @MALOP AND LAN = @LAN)
	BEGIN
		RAISERROR('THÔNG TIN ĐĂNG KÍ THI ĐÃ TỒN TẠI! KHÔNG THỂ THÊM MỚI', 16, 1)
		RETURN
	END
	IF(@LAN = 2)
	BEGIN
		IF NOT EXISTS(SELECT * FROM DBO.BANGDIEM 
		WHERE MAMH = @MAMH AND LAN = 1 AND MASV IN(SELECT MASV FROM SINHVIEN WHERE MALOP = @MALOP))
		BEGIN
			RAISERROR('LẦN 1 CHƯA THI, KHÔNG ĐƯỢC ĐĂNG KÝ LẦN 2!', 16, 1)
			RETURN
		END

		IF NOT EXISTS(SELECT * FROM DBO.GIAOVIEN_DANGKY WHERE MAMH = @MAMH AND MALOP = @MALOP AND LAN = 1 AND NGAYTHI < CONVERT(DATETIME, @NGAYTHI))
		BEGIN
			RAISERROR('NGÀY THI LẦN 2 PHẢI LỚN HƠN NGÀY THI CỦA LẦN 1!', 16, 1)
			RETURN
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CHECKID]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CHECKID]
@Id NVARCHAR(50),
@Type NVARCHAR(15)
AS
BEGIN
	IF(@Type = 'MALOP')
	BEGIN
		IF EXISTS(SELECT * FROM dbo.LOP WHERE dbo.LOP.MALOP = @Id)
			RETURN 1
		ELSE IF EXISTS(SELECT * FROM LINK0.THI_TN.dbo.LOP AS LOP WHERE LOP.MALOP = @Id)
			RETURN 2
	END

	IF(@Type = 'MAKH')
	BEGIN
		IF EXISTS(SELECT * FROM dbo.KHOA WHERE dbo.KHOA.MAKH = @Id)
			RETURN 1
		ELSE IF EXISTS(SELECT * FROM LINK0.THI_TN.dbo.KHOA AS KHOA WHERE KHOA.MAKH = @Id)
			RETURN 2
	END

	IF(@Type = 'MAMONHOC')
	BEGIN 
		IF EXISTS(SELECT * FROM dbo.MONHOC WHERE MAMH = @Id)
			RETURN 1
	END

	IF(@Type = 'MASV')
	BEGIN
		IF EXISTS(SELECT * FROM dbo.SINHVIEN WHERE dbo.SINHVIEN.MASV = @Id)
			RETURN 1
		ELSE IF EXISTS(SELECT * FROM LINK2.THI_TN.dbo.SINHVIEN AS SINHVIEN WHERE SINHVIEN.MASV = @Id)
			RETURN 2
	END
	RETURN 0 

	IF(@Type = 'MAGV')
	BEGIN
		IF EXISTS(SELECT * FROM dbo.GIAOVIEN WHERE dbo.GIAOVIEN.MAGV = @Id)
			RETURN 1
	END
	RETURN 0 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CHECKNAME]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CHECKNAME]
@Name NVARCHAR(50),
@Type NVARCHAR(15)
AS
BEGIN
	IF(@Type = 'TENLOP')
	BEGIN
		IF EXISTS(SELECT * FROM dbo.LOP WHERE dbo.LOP.TENLOP = @Name)
			RETURN 1
		ELSE IF EXISTS(SELECT * FROM LINK0.THI_TN.dbo.LOP AS LOP WHERE LOP.TENLOP = @Name)
			RETURN 2
	END

	IF(@Type = 'TENKH')
	BEGIN
		IF EXISTS(SELECT * FROM dbo.KHOA WHERE dbo.KHOA.TENKH = @Name)
			RETURN 1
		ELSE IF EXISTS(SELECT * FROM LINK0.THI_TN.dbo.KHOA AS KHOA WHERE KHOA.TENKH = @Name)
			RETURN 2
	END

	IF(@Type = 'TENMONHOC')
	BEGIN 
		IF EXISTS(SELECT * FROM dbo.MONHOC WHERE TENMH = @Name)
			RETURN 1
	END

	IF(@Type = 'TENSV')
	BEGIN
		IF EXISTS(SELECT * FROM dbo.SINHVIEN WHERE dbo.SINHVIEN.TEN = @Name)
			RETURN 1
		ELSE IF EXISTS(SELECT * FROM LINK2.THI_TN.dbo.SINHVIEN AS SINHVIEN WHERE SINHVIEN.TEN = @Name)
			RETURN 2
	END
	RETURN 0 

	IF(@Type = 'TENGV')
	BEGIN
		IF EXISTS(SELECT * FROM dbo.GIAOVIEN WHERE dbo.GIAOVIEN.TEN = @Name)
			RETURN 1
	END
	RETURN 0 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_BODE_BY_GV]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GET_BODE_BY_GV]
@magv NVARCHAR(10)
AS
BEGIN
	select * from BODE WHERE MAGV = @magv
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Lay_Thong_Tin_GV_Tu_Login]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_Lay_Thong_Tin_GV_Tu_Login]
@TENLOGIN NVARCHAR (50)
AS
DECLARE @UID NVARCHAR(50)
DECLARE @MAGV NVARCHAR(50)
SELECT @UID=uid, @MAGV = NAME FROM sys.sysusers WHERE sid = SUSER_SID(@TENLOGIN)
 
 SELECT MAGV = @MAGV, 
  HOTEN = (SELECT HO+ ' '+ TEN FROM dbo.GIAOVIEN  WHERE MAGV = @MAGV ),
   TENNHOM= NAME
   FROM sys.sysusers 
   WHERE UID = (SELECT GROUPUID 
                 FROM SYS.SYSMEMBERS 
                   WHERE MEMBERUID= @UID)
GO
/****** Object:  StoredProcedure [dbo].[SP_Lay_Thong_Tin_SV_DangNhap]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_Lay_Thong_Tin_SV_DangNhap]
@masv NVARCHAR(10), @password NVARCHAR(40)
AS
BEGIN 
	SELECT MASV, HOTEN= HO + ' ' + TEN FROM dbo.SINHVIEN  WHERE MASV = @masv AND PASSWORD = @password
END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_BANGDIEM_MH]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_REPORT_BANGDIEM_MH]
@malop CHAR(15),
@mamh CHAR(5),
@lan int
AS
  BEGIN
	/*Todo: get diem chu*/
	SELECT A.MASV, A.HO, A.TEN, ISNULL(B.DIEM, 0) AS DIEM, dbo.FloatToText(ISNULL(B.DIEM, 0)) AS DIEMCHU
	FROM (SELECT MASV,HO, TEN FROM SINHVIEN WHERE MALOP = @malop ) AS A LEFT JOIN 
		  (SELECT MASV, DIEM FROM BANGDIEM WHERE BANGDIEM.LAN = @lan AND BANGDIEM.MAMH = @mamh) AS B
	ON A.MASV = B.MASV
END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_BANGDIEM_MH_GET_LAN]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_REPORT_BANGDIEM_MH_GET_LAN]
@malop CHAR(15),
@mamh varchar(10)
AS
  BEGIN
	SELECT LAN
	FROM BANGDIEM, (SELECT MASV FROM SINHVIEN WHERE MALOP = @malop) AS A
	WHERE BANGDIEM.MASV = A.MASV AND BANGDIEM.MAMH = @mamh
  END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_BANGDIEM_MH_GET_MONHOC]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_REPORT_BANGDIEM_MH_GET_MONHOC]
@malop CHAR(15)
AS
  BEGIN
	SELECT BANGDIEM.MAMH, MONHOC.TENMH
	FROM BANGDIEM, (SELECT MASV, MALOP FROM SINHVIEN WHERE MALOP = @malop) AS A, MONHOC
	WHERE BANGDIEM.MASV = A.MASV AND MONHOC.MAMH = BANGDIEM.MAMH
  END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_GET_DSDK]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_REPORT_GET_DSDK]
@fromDate datetime,
@toDate datetime
AS
BEGIN
	SELECT DISTINCT LOP.TENLOP, MONHOC.TENMH, CONCAT(GIAOVIEN.HO,' ',GIAOVIEN.TEN) AS HOTEN, GVDK.SOCAUTHI, CONVERT(DATE, GVDK.NGAYTHI) AS NGAYTHI, [dbo].[FN_CheckDaThi](GVDK.MAMH, GVDK.MALOP, GVDK.LAN)  AS DATHI  
	FROM GIAOVIEN_DANGKY GVDK 
	inner join LOP ON ( (GVDK.NGAYTHI BETWEEN @fromDate AND @toDate) AND LOP.MALOP = GVDK.MALOP)
	inner join MONHOC ON (GVDK.MAMH = MONHOC.MAMH)
	inner join GIAOVIEN ON (GVDK.MAGV = GIAOVIEN.MAGV)
	ORDER BY NGAYTHI ASC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_XEM_DSDK]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_REPORT_XEM_DSDK]
  @fromDate datetime,
  @toDate datetime
AS
BEGIN
    EXEC LINK0.THI_TN.DBO.SP_REPORT_GET_DSDK @fromDate, @toDate;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_XEM_KQ]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_REPORT_XEM_KQ]
@masv CHAR(15),
@mamh CHAR(5),
@lan int
AS
  BEGIN
	SELECT A.CAUHOI, NOIDUNG, dbo.ConcatValuesWithPeriodAndNewLine(A,B,C,D) AS CACLUACHON, DAP_AN, B.DACHON
	FROM (SELECT CAUHOI, NOIDUNG, A, B, C, D, DAP_AN FROM BODE WHERE BODE.MAMH = @mamh) AS A,
		 (SELECT CAUHOI, DACHON FROM CT_BAITHI WHERE MASV = @masv AND LAN = @lan AND MAMH = @mamh) as B
	where A.CAUHOI = B.CAUHOI
  END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_XEM_KQ_GET_INFO_BANGDIEM]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_REPORT_XEM_KQ_GET_INFO_BANGDIEM]
@masv CHAR(15),
@mamh CHAR(5),
@lan int
AS
  BEGIN
	SELECT NGAYTHI, LOP.TENLOP
	FROM (SELECT NGAYTHI, MASV FROM BANGDIEM WHERE BANGDIEM.MASV = @masv AND BANGDIEM.MAMH = @mamh AND BANGDIEM.LAN = @lan) AS A,
	(SELECT MASV, MALOP FROM SINHVIEN WHERE @masv = SINHVIEN.MASV) AS B, LOP
	WHERE A.MASV = B.MASV AND B.MALOP = LOP.MALOP
  END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_XEM_KQ_GET_LAN]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_REPORT_XEM_KQ_GET_LAN]
@masv CHAR(15),
@mamh varchar(10)
AS
  BEGIN
	SELECT LAN
	FROM BANGDIEM 
	WHERE MASV = @masv and MAMH = @mamh
  END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_XEM_KQ_GET_MONHOC]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_REPORT_XEM_KQ_GET_MONHOC]
@masv CHAR(15)
AS
  BEGIN
	SELECT MONHOC.MAMH, MONHOC.TENMH
	FROM MONHOC, (SELECT MAMH FROM BANGDIEM WHERE BANGDIEM.MASV = @masv) AS A
	where A.MAMH = MONHOC.MAMH
  END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_XEM_KQ_GET_SV]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_REPORT_XEM_KQ_GET_SV]
@malop CHAR(15)

AS
  BEGIN
	SELECT MASV, HO + TEN AS HOTEN
	FROM SINHVIEN 
	WHERE SINHVIEN.MALOP = @malop
  END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_XEMKQ_DSLanThi]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_REPORT_XEMKQ_DSLanThi]
@maSV nchar(8),
@maMH nchar(5)

AS 
	BEGIN
		SELECT LAN FROM BANGDIEM WHERE BANGDIEM.MASV = @maSV AND BANGDIEM.MAMH =@maMH AND BANGDIEM.DIEM IS NULL
	END;
GO
/****** Object:  StoredProcedure [dbo].[SP_TAIKHOAN_CREATE]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TAIKHOAN_CREATE] 
    @loginanme VARCHAR(50),
	@matkhau VARCHAR(50),
	@username VARCHAR(50),
	@role VARCHAR(50)
AS
BEGIN
  DECLARE @response INT
  EXEC @response= SP_ADDLOGIN @loginanme, @matkhau,'THI_TN'                     

  IF (@response =1)  -- LOGIN NAME BI TRUNG
     RETURN 1

  EXEC @response= SP_GRANTDBACCESS @loginanme, @username
  IF (@response =1)  -- USER  NAME BI TRUNG

  BEGIN
       EXEC SP_DROPLOGIN @loginanme
       RETURN 2
  END

 IF @role= 'TRUONG' 
	BEGIN
		EXEC sp_addsrvrolemember @loginanme, 'SecurityAdmin'
		EXEC sp_addrolemember 'Truong', @username
	END

  IF @role= 'COSO'
	BEGIN 
		EXEC sp_addsrvrolemember @loginanme, 'SecurityAdmin'
		EXEC sp_addrolemember 'CoSo', @username
	END
  IF @role= 'GIANGVIEN'
	BEGIN  
		EXEC sp_addrolemember 'GV', @username
	END
  IF @role= 'SINHVIEN'
	BEGIN  
		EXEC sp_addrolemember 'SV', @username
	END
	RETURN 0  -- THANH CONG
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TAIKHOAN_DELETE]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TAIKHOAN_DELETE] 
    @loginname VARCHAR(50),  -- Corrected from @loginanme
    @username VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM GIAOVIEN_DANGKY WHERE MAGV = @username) 
        RAISERROR('NHÂN VIÊN NÀY ĐÃ ĐĂNG KÍ THI Ở CƠ SỞ NÀY', 16, 1)
    ELSE IF EXISTS (SELECT 1 FROM LINK0.THI_TN.dbo.GIAOVIEN_DANGKY WHERE MAGV = @username) 
        RAISERROR('NHÂN VIÊN NÀY ĐÃ ĐĂNG KÍ THI Ở CƠ SỞ KHÁC', 16, 1)
    ELSE IF EXISTS (SELECT 1 FROM BODE WHERE MAGV = @username) 
        RAISERROR('NHÂN VIÊN NÀY ĐÃ TẠO BỘ ĐỀ Ở CƠ SỞ NÀY', 16, 1)
    ELSE IF EXISTS (SELECT 1 FROM LINK0.THI_TN.dbo.BODE WHERE MAGV = @username) 
        RAISERROR('NHÂN VIÊN NÀY ĐÃ TẠO BỘ ĐỀ Ở CƠ SỞ KHÁC', 16, 1)
    ELSE 
    BEGIN
        EXEC sp_dropuser @username
        EXEC sp_droplogin @loginname  -- Corrected from @loginanme
        RETURN 0
    END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TAIKHOAN_DS_GV_CHUACOTK]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_TAIKHOAN_DS_GV_CHUACOTK]
AS
BEGIN
  SELECT MAGV , HO + ' ' + TEN AS HOTEN
  FROM GIAOVIEN WHERE MAGV NOT IN (SELECT MAGV FROM GIAOVIEN 
  WHERE CONVERT(nvarchar, MAGV) IN (SELECT name FROM sys.sysusers))
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TAIKHOAN_DS_GV_COTK]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_TAIKHOAN_DS_GV_COTK]
AS
BEGIN
  SELECT MAGV , HO + ' ' + TEN AS HOTEN
  FROM GIAOVIEN WHERE MAGV IN (SELECT MAGV FROM GIAOVIEN 
  WHERE CONVERT(nvarchar, MAGV) IN (SELECT name FROM sys.sysusers))
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TAIKHOAN_GET_ROLE]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_TAIKHOAN_GET_ROLE]
	@username VARCHAR(50)
AS
BEGIN
	 SELECT role.name AS database_role
	 FROM sys.database_role_members AS members
	 INNER JOIN sys.database_principals AS role ON members.role_principal_id = role.principal_id
	 INNER JOIN sys.database_principals AS u ON members.member_principal_id = u.principal_id
	 WHERE u.name = @username;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TAIKHOAN_GETLOGIN_BY_USERNAME]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_TAIKHOAN_GETLOGIN_BY_USERNAME]
@username NVARCHAR(50)
AS
BEGIN
    SELECT sp.name as loginname
	FROM sys.server_principals sp
	JOIN sys.sysusers su ON sp.sid = su.sid
	WHERE su.name = @username
END
GO
/****** Object:  StoredProcedure [dbo].[SP_THI_CREATE_BANGDIEM]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_THI_CREATE_BANGDIEM]
@masv NVARCHAR (8),
@mamh NVARCHAR (5),
@lan int,
@ngaythi date,
@diem float
AS
	BEGIN
		INSERT INTO BANGDIEM(MASV, MAMH, LAN, NGAYTHI, DIEM) VALUES (@masv, @mamh, @lan, @ngaythi, @diem)
	END
  
 
GO
/****** Object:  StoredProcedure [dbo].[SP_THI_GET_ALL_LAN]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_THI_GET_ALL_LAN]
@malop CHAR(15),
@mamh CHAR(5)
AS
  SELECT LAN
  FROM GIAOVIEN_DANGKY 
  WHERE MALOP = @malop AND MAMH = @mamh 
  GROUP BY LAN
GO
/****** Object:  StoredProcedure [dbo].[SP_THI_GET_GVDK]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_THI_GET_GVDK]
@malop CHAR(15),
@mamh CHAR(5),
@lan int
AS
  SELECT SOCAUTHI, THOIGIAN, TRINHDO
  FROM GIAOVIEN_DANGKY 
  WHERE MALOP = @malop AND MAMH = @mamh AND LAN = @lan 
GO
/****** Object:  StoredProcedure [dbo].[SP_THI_GET_LAN_NGAYTHI]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_THI_GET_LAN_NGAYTHI]
@malop CHAR(15),
@mamh CHAR(5)
AS
  SELECT LAN, NGAYTHI, SOCAUTHI, THOIGIAN, TRINHDO
  FROM GIAOVIEN_DANGKY 
  WHERE MALOP = @malop AND MAMH = @mamh AND NGAYTHI >= GETDATE()
GO
/****** Object:  StoredProcedure [dbo].[SP_THI_GET_LOPHOC_BY_SV]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_THI_GET_LOPHOC_BY_SV]
@masv NVARCHAR (8)
AS
  SELECT LOP.MALOP, LOP.TENLOP
  FROM LOP, (SELECT MALOP FROM SINHVIEN WHERE MASV = @masv) as A
  WHERE LOP.MALOP = A.MALOP
 
GO
/****** Object:  StoredProcedure [dbo].[SP_THI_GET_MONHOC]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_THI_GET_MONHOC]
@masv NVARCHAR (15),
@malop NVARCHAR (10)
AS
  SELECT MONHOC.MAMH, MONHOC.TENMH
  FROM MONHOC, (SELECT MAMH FROM GIAOVIEN_DANGKY WHERE MALOP = @malop AND NGAYTHI >= GETDATE()) as A
  WHERE MONHOC.MAMH = A.MAMH AND @masv not in (select MASV from BANGDIEM WHERE A.MAMH = MAMH AND @masv = MASV)
 
GO
/****** Object:  StoredProcedure [dbo].[SP_THI_GET_MONHOC_BY_LOP]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_THI_GET_MONHOC_BY_LOP]
@malop NVARCHAR (15),
@ngaythi datetime
AS
  SELECT MONHOC.MAMH, MONHOC.TENMH
  FROM MONHOC, (SELECT MAMH FROM GIAOVIEN_DANGKY WHERE MALOP = @malop AND NGAYTHI >= @ngaythi) as A
  WHERE MONHOC.MAMH = A.MAMH
 
GO
/****** Object:  StoredProcedure [dbo].[SP_THI_GET_MONHOC_BY_SV]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_THI_GET_MONHOC_BY_SV]
@masv NVARCHAR (15)
AS
  SELECT MONHOC.MAMH, MONHOC.TENMH
  FROM MONHOC, (SELECT MAMH FROM BANGDIEM B WHERE B.DIEM IS NULL AND B.MASV = @masv ) as A
  WHERE MONHOC.MAMH = A.MAMH
 
GO
/****** Object:  StoredProcedure [dbo].[SP_THI_GET_NGAYTHI]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_THI_GET_NGAYTHI]
@malop CHAR(15),
@mamh CHAR(5),
@lan int
AS
  SELECT NGAYTHI
  FROM GIAOVIEN_DANGKY 
  WHERE MALOP = @malop AND MAMH = @mamh AND LAN = @lan
GO
/****** Object:  StoredProcedure [dbo].[SP_THI_GET_QUESTION]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_THI_GET_QUESTION]
    @maMonHoc NCHAR(5), @trinhDo NChar(1), @soCau int
AS

BEGIN
	DECLARE @trinhDo2 Nchar(1) = 'N'
	DECLARE @countQuestion int = 0
	DECLARE @countQuestionCungTrinhDo int = 0
	DECLARE @countQuestionTrinhDoDuoi int = 0

	set @countQuestionCungTrinhDo = (select count(*) from BODE where (MAMH = @maMonHoc and TRINHDO = @trinhDo))

	if (@trinhDo = 'A') 
		set @trinhDo2 = 'B'
	else if (@trinhDo = 'B')
		set @trinhDo2 = 'C' 
	
	set @countQuestionTrinhDoDuoi = (select count(*) from BODE where (MAMH = @maMonHoc and TRINHDO = @trinhDo2))
	set @countQuestion = @countQuestionCungTrinhDo+@countQuestionTrinhDoDuoi
		
		--set @countQuestion = @countQuestionCungTrinhDo

	if(@countQuestion <@soCau or @countQuestionCungTrinhDo<(@soCau*70/100))
		begin
			RAISERROR(N'khong du cau hoi',16,1)
		end
	
	-- tạo bảng tạm chưa các câu hỏi tại tất cả các site theo input ban đầu
	create table AtSiteTable(
	CAUHOI int primary key,
	TRINHDO char(1),
	NOIDUNG nvarchar(max),
	A nvarchar(max),
	B nvarchar(max),
	C nvarchar(max),
	D nvarchar(max),
	DAP_AN nchar(1),
	)

	select * into CungTrinhDoAtSiteTable from BODE  where MAMH = @maMonHoc and TRINHDO = @trinhDo and MAGV in (Select MAGV from GIAOVIEN where MAKH in(select MAKH from KHOA))
	select * into TrinhDoDuoiAtSiteTable from BODE  where MAMH = @maMonHoc and TRINHDO = @trinhDo2 and MAGV in (Select MAGV from GIAOVIEN where MAKH in(select MAKH from KHOA))
	
	Insert into AtSiteTable
			select CAUHOI,TRINHDO,CAST(NOIDUNG as nvarchar(max)),CAST(A as nvarchar(max)),CAST(B as nvarchar(max)),CAST(C as nvarchar(max)),
			CAST(D as nvarchar(max)),DAP_AN from CungTrinhDoAtSiteTable
			UNION
			select CAUHOI,TRINHDO,CAST(NOIDUNG as nvarchar(max)),CAST(A as nvarchar(max)),CAST(B as nvarchar(max)),CAST(C as nvarchar(max)),
			CAST(D as nvarchar(max)),DAP_AN  from TrinhDoDuoiAtSiteTable 
	
	Declare @countCungTrinhDoAtSite int = (select count(*) from CungTrinhDoAtSiteTable)
	Declare @countTrinhDoDuoiAtSite int = (select count(*) from TrinhDoDuoiAtSiteTable)
	if((@countCungTrinhDoAtSite+@countTrinhDoDuoiAtSite) < @soCau OR @countCungTrinhDoAtSite < (@soCau*70/100))
		begin
			select * into CungTrinhDoOtherSiteTable from BODE  where MAMH = @maMonHoc and TRINHDO = @trinhDo and MAGV in (Select MAGV from GIAOVIEN where MAKH in(select MAKH from LINK1.THI_TN.dbo.KHOA))
			select * into DuoiTrinhDoOtherSiteTable from BODE  where MAMH = @maMonHoc and TRINHDO = @trinhDo2 and MAGV in (Select MAGV from GIAOVIEN where MAKH in(select MAKH from LINK1.THI_TN.dbo.KHOA))

			Insert into AtSiteTable
			select CAUHOI,TRINHDO,CAST(NOIDUNG as nvarchar(max)),CAST(A as nvarchar(max)),CAST(B as nvarchar(max)),CAST(C as nvarchar(max)),
			CAST(D as nvarchar(max)),DAP_AN from CungTrinhDoOtherSiteTable
			UNION
			select CAUHOI,TRINHDO,CAST(NOIDUNG as nvarchar(max)),CAST(A as nvarchar(max)),CAST(B as nvarchar(max)),CAST(C as nvarchar(max)),
			CAST(D as nvarchar(max)),DAP_AN  from DuoiTrinhDoOtherSiteTable 
			drop table CungTrinhDoOtherSiteTable
			drop table DuoiTrinhDoOtherSiteTable
		end
	Declare @slCanLayCungTrinhDo int, @slCanLayDuoiTrinhDo int
		set @slCanLayCungTrinhDo = @soCau*70/100
		if ((@slCanLayCungTrinhDo + @countQuestionTrinhDoDuoi)<@soCau)
			set @slCanLayCungTrinhDo = @slCanLayCungTrinhDo + (@soCau - (@slCanLayCungTrinhDo+@countQuestionTrinhDoDuoi))
			set @slCanLayDuoiTrinhDo = @soCau - @slCanLayCungTrinhDo
		
	select top (@slCanLayCungTrinhDo) * into temp1 from AtSiteTable where TRINHDO = @trinhDo
	ORDER BY NEWID()
	
	select top (@slCanLayDuoiTrinhDo) * into temp2 from AtSiteTable where TRINHDO = @trinhDo2
	ORDER BY NEWID()

	select CAUHOI,CAST(NOIDUNG as nvarchar(max)) as [NOIDUNG],CAST(A as nvarchar(max)) as [A],CAST(B as nvarchar(max)) as [B],CAST(C as nvarchar(max)) as [C],
	CAST(D as nvarchar(max)) as [D],DAP_AN  from temp1
	UNION
	select CAUHOI,CAST(NOIDUNG as nvarchar(max)) as [NOIDUNG],CAST(A as nvarchar(max)) as [A],CAST(B as nvarchar(max)) as [B],CAST(C as nvarchar(max)) as [C],
	CAST(D as nvarchar(max)) as [D],DAP_AN  from temp2

	drop table AtSiteTable
	drop table CungTrinhDoAtSiteTable
	drop table TrinhDoDuoiAtSiteTable
	drop table temp1
	drop table temp2
END
GO
/****** Object:  StoredProcedure [dbo].[SP_THI_SAVE_CT_BAITHI]    Script Date: 6/27/2024 11:32:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_THI_SAVE_CT_BAITHI]
@ctbaithi_table BAITHI READONLY,
@masv NVARCHAR (8),
@mamh NVARCHAR (5),
@lan int,
@ngaythi date,
@diem float
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; 
        DECLARE @RowCount INT = (SELECT COUNT(*) FROM @ctbaithi_table);  
        DECLARE @cauhoi int, @dachon char(1), @causo int
		/*save bang diem*/
        EXEC [SP_THI_CREATE_BANGDIEM] @masv, @mamh, @lan, @ngaythi, @diem

		/*save ctbaithi*/
        WHILE @RowCount > 0 
        BEGIN  
            SELECT @cauhoi = CAUHOI, @dachon = DACHON, @causo = CAUSO
            FROM @ctbaithi_table 
            ORDER BY CAUSO DESC OFFSET @RowCount - 1 ROWS FETCH NEXT 1 ROWS ONLY;  

            INSERT INTO CT_BAITHI(MASV, MAMH, LAN, CAUHOI, DACHON, CAUSO) 
            VALUES (@masv , @mamh , @lan , @cauhoi , @dachon , @causo );

            SET @RowCount -= 1;  
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
