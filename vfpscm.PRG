*
* class to convert vfp forms into xmls and viceverza
*
* some methods taked from 
* http://vfpx.codeplex.com/wikipage?title=Alternate%20SCCText
* 
*
define class vfpscm as custom


	*
	* creates an xml representation from a form
	*
	function scx2xml(cFileScx, cFileXml)
		* crear una copia de la forma, en el cursor llamado scxrecord
		use (cFileScx) in 0 shared alias thetable
		if select('thetable')==0
			return
		endif
		select * from thetable into cursor record readwrite
		select thetable
		use
		select record
		* limpiar codigo compilado y ordenar propiedades y metodos
		replace ;
			objcode		with '',;
			ole			with iif(empty(ole),'',strconv(ole, 13)),;
			properties	with this.sortproperties(properties) ,;
			methods		with this.sortmethods(methods), ;
			reserved3	with this.sortproperties(reserved3) ;
			all
		*index on this.sortScx() tag x
		cursorToXml('',cFileXml,1,512+48)
		use
	return


	*
	* creates a form since an xml representation
	*
	function xml2scx(cFileXml, cFileScx)
		this.createNewForm()
		xmlToCursor( cFileXml, 'newform', 512+8192)
		select newForm
		replace ;
			ole			with iif(empty(ole),'',strconv(ole, 14)),;
			properties	with this.sortproperties(properties) ,;
			methods		with this.sortmethods(methods) ,;
			reserved3	with this.sortproperties(reserved3) ;
			all
		*index on this.sortScx() tag x
		copy to (cFileScx)
		use
		if '.vcx' $ lower(cFileScx)
			compile classlib(cFileScx)
		endif
		if '.scx' $ lower(cFileScx)
			compile form (cFileScx)
		endif
	return


	*
	* creates the table for a new form
	*
	function createNewForm
		create cursor newform ( ;
			platform	c(8),;
			uniqueid	c(10),;
			timestamp	n(10),;
			class		m(4),;
			classloc	m(4),;
			baseclass	m(4),;
			objname		m(4),;
			parent		m(4),;
			properties	m(4),;
			protected	m(4),;
			methods		m(4),;
			objcode		m(4),;
			ole			m(4),;
			ole2		m(4),;
			reserved1	m(4),;
			reserved2	m(4),;
			reserved3	m(4),;
			reserved4	m(4),;
			reserved5	m(4),;
			reserved6	m(4),;
			reserved7	m(4),;
			reserved8	m(4),;
			user		m(4);
		)
	return



	*
	* sortProperties
	*
	* sort properties in aphabetical order, because vfp change order
	*
	function sortProperties(cProp)
	local cRetVal,nTotLin,nLin
		* Si properties es vacio, regresar vacio
		if empty(cProp)
			return cProp
		endif
		* Es un grid, dejarlo tal cual
		lIsGrid = at('Column1.Name',cProp)>0
		lIsPageFrame = at('PageCount',cProp)>0
		nTotLin = ALines(aProp,cProp)
		* Asegurarme que todas las lineas terminen en CrLf
		for nLin=1 to nTotLin
			if right(aProp[nLin],2)<>chr(13)+chr(10)
				aProp[nLin] = aProp[nLin]+chr(13)+chr(10)
			endif
		next
		if lIsGrid or lIsPageFrame
			* No ordenar propiedades cuando el objeto sea el grid
		else
			* Ordenar las propiedades en orden alfabetico
			* aSort(aProp)
		endif
		* Volver a crear el memo
		cRetVal = ''
		for nLin=1 to nTotLin
			cRetVal = cRetVal + aProp[nLin]
		next
	return cRetVal


	*
	* sortMethods
	*
	* sort methods in aphabetical order
	*
	function sortMethods(cMethods)
	local i,cRetVal,nTotMethods,nLine,nTotLines
		nTotMethods = 0
		nTotLines = alines(aText,cMethods)
		* Recorrer todas las lineas
		* Formar el arreglo aMethods con TODO el codigo de cada methodo
		* Crear un nuevo elemento del arreglo, cada vez que cambia de metodo
		for nLine=1 to nTotLines
			if left(aText[nLine],10)=='PROCEDURE '
				nTotMethods = nTotMethods + 1
				dimension aMethods[nTotMethods]
				aMethods[nTotMethods] = ''
			endif
			if nTotMethods>0
				aMethods[nTotMethods] = aMethods[nTotMethods] + allt(aText[nLine]) + chr(13)+chr(10)
			endif
		next
		cRetVal = ''
		if nTotMethods>0
			asort(aMethods)
			for i=1 to nTotMethods
				cRetVal = cRetVal + aMethods[i]
			next
		endif
	return cRetVal



	*
	* Ordena los registros de un scx
	* Los primeros 2 son reservados, siempre deben ir al inicio
	* El ultimo, siempre es reservado, siempre debe ir al final
	* Los demas los ordena en base al nombre. A Excepcion de los encabezados de los grids, los pone antes
	*
	function sortscx
		cRetVal = ''
		do case
		case allt(UNIQUEID)=='Screen' or allt(UNIQUEID)=='Class'
			cRetVal = '1'
		case allt(BASECLASS)=='dataenviroment'
			cretval = '2'
		case empty(OBJNAME)
			cRetVal = 'zzzzz'
		case not empty(PARENT)
			cRetVal = LOWER(TRIM(PARENT)  + IIF(EMPTY(PARENT),"",".") + IIF(LOWER(BASECLASS)="header","0","")+LOWER(objname))
		case allt(platform)=='COMMENT'
			cRetVal = alltrim(OBJNAME) + '.zzzzz'
		otherwise
			cRetVal = alltrim(OBJNAME)
		endcase
	return PADR( cRetVal , 100)

	

	* regresa el timestamp mayor de todos los registros del archivo xml
	* lo regresa en formato numerico
	function getModXml(cFileXml)
	local nModXml, cXml, nPos, cTimeStamp
		nModXml = 0
		if file(cFileXml)
			cXml = filetostr(cFileXml)
			* obtener mayor timestamp de todos los registros
			do while .t.
				nPos = at('<timestamp>',cXml)
				if nPos==0
					exit
				endif
				cTimeStamp = substr(cXml, nPos+11, 20)
				cTimeStamp = substr(cTimeStamp, 1, at('<', cTimeStamp)-1)
				nModXml = max(nModXml, val(cTimeStamp))
				cXml = substr(cXml, nPos + 11)
			enddo
		endif
	return nModXml
		
	* regresa la fecha de creacion y modificacion del scx
	function getModScx (cFileScx, nCreated, nModified)
		nCreated = 0
		nModified = 0
		if file(cFileScx)
			use (cFileScx) shared alias theform in 0
			select theform
			scan
				if theform.timestamp>0 
					if nCreated=0
						nCreated = theform.timestamp
					endif
					nCreated = min(nCreated, theform.timestamp)
				endif
				nModified = max(nModified, theform.timestamp)
			endscan
			use
		endif
	return


enddefine