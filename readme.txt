
VfpScm  Visual FoxPro Source Code Managment
===========================================

Convert VFP forms and classes into text files, to use a Source Code Management (SCM) like Git, Mercurial, Subversion or CVS in our Vfp projects.

Functions.
	1. Convert vfp forms and classes into text files xml, to store them in a repository.
	2. Deconvert xml files into vfp forms and classes.
Notes:
	- Use VFP9 to compile it. Use xmlToCursor() and cursorToXml()
	- I have used with no problem in VFP6 projects
	- Executable file is in prod/vfpscm.exe needs vfp9 runtime
	
	
	
ESPAÑOL
=======

El objetivo de VfpScm es usar Git con VFP para almacenar nuestras formas (SCX) y clases (VCX) en archivos textos XML que puedan ser almacenados en un repositorio GIT para revisar los cambios en el código fuente.

Basicamente tiene 2 funciones:
	1. Convertir las formas (SCX) y clases (VCX) en archivos XML para almacenarlos en un repositorio GIT
	2. Reconvertir los archivos XML en formas y VCX cuando recibimos un repositorio
	
Notas:
	- Debe compilarse usando VFP9 porque usa la funcion: xmlToCursor() y curstoToXml()
	- Lo uso sin problemas en los proyectos de VFP6.
	- No lo he probado con proyectos de VFP9
	- El programa ejecutable se encuentra en: prod/vfpscm.exe  requiere el runtime de vfp9
	

Estando en VFP puedes:

	Recompilar programa:
	do make
	
	Editar ventana principal
	modi form vfpscm
	
	Editar clase que convierte los archivos
	modi comm vfpscm
	

---------------------------------- 
Ignacio Gutiérrez Torrero
SAIT Software Administrativo
www.sait.com.mx
+52(653)534-8800
Monterrey México
-----------------------------------
