import example.*

class Cambio {
	const nombreDelArchivo
	
	method aplicar(carpeta) {
		const archivo = self.archivoInteresado(carpeta)
		self.aplicarCambioPosta(carpeta, archivo)
	}
	
	method archivoInteresado(carpeta) = carpeta.encontrarArchivo(nombreDelArchivo)
	
	method aplicarCambioPosta(carpeta, archivo)
	
	method afectaA(nombreArchivo) = nombreArchivo == nombreDelArchivo
}


class Crear inherits Cambio {
	
	override method archivoInteresado(carpeta) = new Archivo(nombre = nombreDelArchivo) 

	override method aplicarCambioPosta(carpeta, archivo) {
		carpeta.agregar(archivo)
	}
	
	method opuesto() = new Eliminar(nombreDelArchivo = nombreDelArchivo)
	
}

class Eliminar inherits Cambio {

	override method aplicarCambioPosta(carpeta, archivo) {
		carpeta.eliminar(archivo)
	}
	
	method opuesto() = new Crear(nombreDelArchivo = nombreDelArchivo)
	
}


class Agregar inherits Cambio {
	const contenidoAAgregar
	
	override method aplicarCambioPosta(carpeta, archivo) {
		archivo.agregarContenido(contenidoAAgregar)
	}
	
	method opuesto() = new Sacar(nombreDelArchivo = nombreDelArchivo, contenidoASacar = contenidoAAgregar)
	
}

class Sacar inherits Cambio {
	const contenidoASacar
	
	override method aplicarCambioPosta(carpeta, archivo) {
		archivo.sacarContenido(contenidoASacar)
	}

	method opuesto() = new Agregar(nombreDelArchivo = nombreDelArchivo, contenidoAAgregar = contenidoASacar)
	
}

