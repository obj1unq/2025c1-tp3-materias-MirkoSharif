class Carrera {

    var nombre
    var materias = #{}

    method nombre() = nombre

    method materias() = materias

    method agregarAMaterias(materia) = materias.add(materia)
}

class Materia  {

    const nombre
    const inscriptos = []
    const correlativas = #{}
    const listaEspera  = []
    var cupo

    method nombre() = nombre

    method inscriptos() = inscriptos

    method esMateria(_materia) {
        return nombre == _materia
    }

    method agregarAInscripto(estudiante) = inscriptos.add(estudiante)

    method correlativas() = correlativas

    method listaEspera() = listaEspera

    method agregarAListaEspera(estudiante) = listaEspera.add(estudiante)

    method estaInscriptoEn(materia, _estudiante) {
        return self.inscriptos().any({estudiante => estudiante == _estudiante})
    }

    method resultadoDeInscripcion(estudiante) {
        if (not self.hayCuposEnMateria()) {
            self.agregarAListaEspera(estudiante)
        } else {
            self.agregarAInscripto(estudiante)
        }
    }

    method hayCuposEnMateria() {
        return self.nroDeInscriptos() < cupo
    }

    method nroDeInscriptos() {
        return inscriptos.count()
    }

    method darDeBajaAEstudiante(estudiante) {
        if (not self.hayEnInscriptoEstudiante(estudiante)) {
            self.sacarDeListaDeEsperaAEstudiante(estudiante)
        } else {
            const primeroDeEspera = listaEspera.first()
            self.sacarDeInscriptoAEstudiante(estudiante)
            self.sacarDeListaDeEsperaAEstudiante(primeroDeEspera)
            self.agregarAInscripto(primeroDeEspera)
        }
    }

    method hayEnInscriptoEstudiante(estudiante) {
        return inscriptos.contains(estudiante)
    }

    method hayEnListaDeEsperaEstudiante(estudiante) {
        return listaEspera.contains(estudiante)
    }

    method hayEnInscriptoOEsperaEstudiante(estudiante) {
        return self.hayEnInscriptoEstudiante(estudiante) || self.hayEnListaDeEsperaEstudiante(estudiante)
    }

    method sacarDeListaDeEsperaAEstudiante(estudiante) {
        listaEspera.remove(estudiante)
    }

    method sacarDeInscriptoAEstudiante(estudiante) {
        inscriptos.remove(estudiante)
    }
}
class Estudiante {

    var carreras = #{}
    var aprobadas = #{}

    
    method agregarCarrera(carrera) = carreras.add(carrera)

    method agregarAprobada(materia) = aprobadas.add(materia)

    method aprobar(materia, nota) {
        self.validarTieneAprobada(materia, nota)
        self.agregarAprobada(new Aprobada(materia = materia, nota = nota))
    }

    method validarTieneAprobada(materia, nota) {
        if(self.tieneAprobada(materia)) {
            self.error("Tiene la materia aprobada")
        }
    }

    method tieneAprobada(materia){
        return aprobadas.any({aprobada => materia.esMateria(materia)})
    }

    method totalEnNotas() {
        return aprobadas.sum({ aprobada => aprobada.nota()})
    }

    method nroDeAprobadas() {
        return aprobadas.size()
    }

    method promedioDeNotas() {
        return self.totalEnNotas() / self.nroDeAprobadas()
    }

    method materiasDeCarrera() {
        return carreras.map({carrera => carrera.materias()})
    }

    method todasLasMateriasDeCarrerasQueCursa() {  
        return [self.materiasDeCarrera()].flatten().asSet()
    }

    method puedeAnotarseEn(materia) {
        return self.estaEnCarreraCon(materia) && not self.tieneAprobada(materia) && self.cumpleCondicionesInscripcionCon(materia) 
    }

    method estaEnCarreraCon(materia) {
        return not carreras.isEmpty() && self.tieneCarreraCon(materia)
    }

    method tieneCarreraCon(materia) {
        return self.materiasDeCarrera().any({materia => materia == materia})
    }

    method cumpleCondicionesInscripcionCon(materia) {
        return not materia.estaInscriptoEn(materia, self) && self.tieneAprobadaCorrelativasDe(materia)
    }
    
    method tieneAprobadaCorrelativasDe(materia) {
        return materia.correlativas().all({correlativa => self.tieneAprobada(correlativa)})
    }

    method inscribirAMateria(materia) {
        if (not self.puedeAnotarseEn(materia)) {
            self.error("No cumple con las condiciones para inscribirse")
        } else {
            materia.resultadoDeInscripcion(self)
        } 
    }

    method darDeBajaEnMateria(materia) {
        materia.darDeBajaAEstudiante(self)
    }

    method informacionUtil() {
        return self.todasLasMateriasDeCarrerasQueCursa().filter({materia => materia.hayEnInscriptoOEsperaEstudiante(self)})
    }

    method materiasEnDondeEstaInscripto(carrera) {
        self.validarInscriptoEn(carrera)
        return carrera.materias().filter({materia => self.puedeAnotarseEn(materia)})
    }

    method validarInscriptoEn(carrera) {
        if (not self.estaEnCarrera(carrera)) {
            self.error("No esta inscripto en la carrera")
        }
    }

    method estaEnCarrera(carrera) {
        return carreras.contains(carrera)
    }

}

class Aprobada {
  
    var materia
    var nota 

    method materia() = materia

    method nota() = nota

}