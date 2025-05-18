class Carrera {

    var nombre
    var materias 

    method nombre() = nombre

    method materias() = materias

    method agregarAMaterias(materia) = materias.add(materia)
}

class Materia  {

    var nombre
    var carrera
    var inscriptos = []
    var correlativas 
    var listaEspera = []
    var cupo

    method nombre() = nombre

    method carrera() = carrera

    method inscriptos() = inscriptos

    method agregarAInscripto(estudiante) = inscriptos.add(estudiante)

    method correlativas() = correlativas

    method listaEspera() = listaEspera

    method agregarAListaEspera(estudiante) = listaEspera.add(estudiante)

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

    var carreras 
    var aprobada 

    
    method agregarCarrera(carrera) = carreras.add(carrera)

    method agregarAprobada(materia) = aprobada.add(materia)

    method aprobar(materia, nota) {
        if(self.tieneAprobada(materia)) {
            self.error("Tiene la materia aprobada")
        } else {
            self.agregarAprobada(new Aprobacion(materia = materia, nota = nota))
        }
    }

    method tieneAprobada(materia){
        return aprobada.any({aprobada => aprobada.materia() == materia})
    }

    method totalEnNotas() {
        return aprobada.sum({ aprobada => aprobada.nota()})
    }

    method nroDeMaterias() {
        return aprobada.count()
    }

    method promedioDeNotas() {
        return self.totalEnNotas() / self.nroDeMaterias()
    }

    method materiasDeCarrera() {
        return carreras.map({carrera => carrera.materias()})
    }

    method todasLasMateriasDeCarrerasQueCursa() {  
        return [self.materiasDeCarrera()].flatten()
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
        return not self.estaInscriptoEn(materia) && self.tieneAprobadaCorrelativasDe(materia)
    }
    
    method estaInscriptoEn(materia) {
        return materia.inscriptos().any({estudiante => estudiante == self})
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
        if (not self.estaEnCarrera(carrera)) {
            return[]    
        } else {
            return carrera.materias().filter({materia => self.puedeAnotarseEn(materia)})
        }
    }

    method estaEnCarrera(carrera) {
        return carreras.contains(carrera)
    }

}

class Aprobacion {
  
    var materia
    var nota 

    method materia() = materia

    method nota() = nota

}