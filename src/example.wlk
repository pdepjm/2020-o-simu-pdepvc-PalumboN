// PUNTO 1
// Averiguar si una carpeta contiene un archivo con un nombre dado.
// Objs candidatos: Carpeta (clase), Archivo 
// carpeta.contiene("parcial.wlk")
// PUNTO 2
// Dada una carpeta, aplicar todos los cambios de un commit, 
// lo que implica que la carpeta quede modificada
// Commit, cambios sobre una carpeta
// 1° Creo el commit con los cambios que quiero realizar en la carpeta (pero sin aplicar!)
// const commit = new Commit(cambios=[new Crear(nombreDelArchivo = "parcial.wlk")])
// 2° Al aplicar ese commit sobre una carpeta sufre las modificaciones de los cambios
// commit.aplicarEn(carpeta) [Se lo pedimos al commit porque es quien tiene los cambios a aplicar]
// carpeta.aplicar(commit)
// carpeta.aplicarCambios(muchosCambios) [Acá no se reifica (aparece en el código) la idea de commit :-1:]

class Carpeta {

	const nombre
	const archivos = #{}

	method contiene(nombreDelArchivo) = archivos.any({ archivo => archivo.tenesNombre(nombreDelArchivo) })

	method agregar(archivo) {
		self.validarNuevoArchivo(archivo)
		archivos.add(archivo)
	}

	method eliminar(archivo) {
		archivos.remove(archivo)
	}

	method validarNuevoArchivo(archivo) {
		if (self.contiene(archivo.nombre())) {
			self.error("Ya existe un archiuvo con ese nombre")
		}
	}

	method encontrarArchivo(nombreDelArchivo) = archivos.findOrElse({ archivo => archivo.tenesNombre(nombreDelArchivo) }, { self.error("No existe un archivo con ese nombre") })

}

class Archivo {

	const property nombre
	var property contenido = ""

	method tenesNombre(nombreDelArchivo) = nombreDelArchivo == nombre

	method agregarContenido(nuevoContenido) {
		contenido = contenido + nuevoContenido
	}

	method sacarContenido(nuevoContenido) {
		contenido = contenido - nuevoContenido
	/* Esto no funciona ni en pedo pero no me interesa */
	}

}

// Obtener el revert de un commit.
// commit.revert() -> Nuevo commit

class Commit {

	const descripcion
	const cambios = []
	const property autor

	method aplicarEn(carpeta) {
		cambios.forEach({ cambio => cambio.aplicar(carpeta)})
	}
	
	method afectaA(nombreArchivo) = cambios.any({ cambio  => cambio.afectaA(nombreArchivo)})

	method revert() = new Commit(
		autor = autor,
		descripcion = "revert " + descripcion,
		cambios = cambios.map({ cambio => cambio.opuesto() }).reverse()
	)
}

// PUNTO 3
// Hacer el checkout de una branch en una carpeta:
// branch.checkoutEn(carpeta)
// PUNTO 4
// Conocer el log de un archivo a partir de una branch
// branch.log(nombreArchivo) -> commits

// PUNTO 6
// Commitear: Hacer que un usuario commitee en un branch, en caso de tener los permisos necesarios.
// branch.commitear(usuario, commit)

class Branch {

	const commits = []
	const colaboradores = []

	method checkoutEn(carpeta) {
		commits.forEach({ commit => commit.aplicarEn(carpeta)})
	}
	
	method log(nombreArchivo) = commits.filter({commit => commit.afectaA(nombreArchivo)})

	method commitear(commit) {
		self.validarPermisos(commit.autor())
		commits.add(commit)
	}
	
	method validarPermisos(usuario) {
		if (not usuario.puedeCommitearEn(self)) {
			self.error("No tiene permisos necesarios")
		}
	}
	
	method esColaborador(usuario) = colaboradores.contains(usuario)
	
	method cantidadDeCommits() = commits.size()
}

class Usuario {
	var property rol
	
	method puedeCommitearEn(branch) = branch.esColaborador(self) or rol.puedeCommitearUsuarioEn(branch)
}

// Esto son objects y se van a compartir entre distintos usuarios.
// No hay problema porque son objetos stateless (o sea, SIN ESTADO)
object comun {
	method puedeCommitearUsuarioEn(branch) = false // TODO: Ver qué onda la lógica general, este caso ya está resuelto ahí. Devuelve false porque no tiene ninguna otra condición
}

object admin {
	method puedeCommitearUsuarioEn(branch) = true
}

object bot {
	method puedeCommitearUsuarioEn(branch) = branch.cantidadDeCommits() > 10
}
