-- ======================================
-- BASE DE DATOS: CalmaVR_Formularios
-- Modelo relacional según diagrama SSMS
-- ======================================

IF DB_ID('CalmaVR_Formularios') IS NULL
BEGIN
    EXEC('CREATE DATABASE CalmaVR_Formularios');
END;
GO

USE CalmaVR_Formularios;
GO

-- Limpieza previa
IF OBJECT_ID('dbo.RespuestaDetalle','U') IS NOT NULL DROP TABLE dbo.RespuestaDetalle;
IF OBJECT_ID('dbo.Respuesta','U') IS NOT NULL DROP TABLE dbo.Respuesta;
IF OBJECT_ID('dbo.OpcionPregunta','U') IS NOT NULL DROP TABLE dbo.OpcionPregunta;
IF OBJECT_ID('dbo.Pregunta','U') IS NOT NULL DROP TABLE dbo.Pregunta;
IF OBJECT_ID('dbo.Formulario','U') IS NOT NULL DROP TABLE dbo.Formulario;
GO

-- ======================================
-- TABLA: FORMULARIO
-- ======================================
CREATE TABLE dbo.Formulario (
    FormularioID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

-- ======================================
-- TABLA: PREGUNTA
-- ======================================
CREATE TABLE dbo.Pregunta (
    PreguntaID INT IDENTITY(1,1) PRIMARY KEY,
    FormularioID INT NOT NULL,
    Enunciado NVARCHAR(300) NOT NULL,
    Tipo VARCHAR(20) NOT NULL,
    Orden INT NOT NULL,
    CONSTRAINT FK_Pregunta_Formulario FOREIGN KEY (FormularioID)
        REFERENCES dbo.Formulario(FormularioID)
);

-- ======================================
-- TABLA: OPCION_PREGUNTA
-- ======================================
CREATE TABLE dbo.OpcionPregunta (
    OpcionID INT IDENTITY(1,1) PRIMARY KEY,
    PreguntaID INT NOT NULL,
    TextoOpcion NVARCHAR(200) NOT NULL,
    Valor NVARCHAR(50) NULL,
    Orden INT NOT NULL,
    CONSTRAINT FK_OpcionPregunta_Pregunta FOREIGN KEY (PreguntaID)
        REFERENCES dbo.Pregunta(PreguntaID)
);

-- ======================================
-- TABLA: RESPUESTA
-- ======================================
CREATE TABLE dbo.Respuesta (
    RespuestaID INT IDENTITY(1,1) PRIMARY KEY,
    FormularioID INT NOT NULL,
    CodigoAnonimo VARCHAR(10) NOT NULL,
    FechaEnviado DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Respuesta_Formulario FOREIGN KEY (FormularioID)
        REFERENCES dbo.Formulario(FormularioID)
);

-- ======================================
-- TABLA: RESPUESTA_DETALLE
-- ======================================
CREATE TABLE dbo.RespuestaDetalle (
    RespuestaDetalleID INT IDENTITY(1,1) PRIMARY KEY,
    RespuestaID INT NOT NULL,
    PreguntaID INT NOT NULL,
    ValorTexto NVARCHAR(MAX) NULL,
    ValorNumero DECIMAL(18,4) NULL,
    FechaRegistro DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_RespuestaDetalle_Respuesta FOREIGN KEY (RespuestaID)
        REFERENCES dbo.Respuesta(RespuestaID) ON DELETE CASCADE,
    CONSTRAINT FK_RespuestaDetalle_Pregunta FOREIGN KEY (PreguntaID)
        REFERENCES dbo.Pregunta(PreguntaID)
);

-- ======================================
-- ÍNDICES OPCIONALES
-- ======================================
CREATE INDEX IX_Pregunta_Formulario ON dbo.Pregunta(FormularioID);
CREATE INDEX IX_Respuesta_Formulario ON dbo.Respuesta(FormularioID);
CREATE INDEX IX_RespuestaDetalle_Respuesta ON dbo.RespuestaDetalle(RespuestaID);
GO
