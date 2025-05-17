class Carrera {

    var nombre
    var materias = []

    method nombre() = nombre

    method materias() = materias
}

const programacion = new Carrera(nombre = "Programación") {}

class Materia  {

    var nombre
    var carrera
    var inscriptos = []

    method nombre() = nombre

    method carrera() = carrera

    method inscriptos() = inscriptos
}

const matematica1 = new Materia(nombre = "Matemática 1", carrera = programacion) {}

const objetos1 = new Materia(nombre = "Objetos 1", carrera = programacion) {}

class Estudiante {

    var nombre
    var carrera = []
    var aprobada = []

    method agregarCarrera(_carrera) = carrera.add(_carrera)

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
        return carrera.forEach({carrera => carrera.materias()})
    }

    method inscripto() {
        return [self.materiasDeCarrera()].flatten()
    }

    method puedeAnotarseEnMateria(materia) {
        return self.estaEnCarreraCon(materia) && self.tieneAprobada(materia) && not self.estaInscriptoEn(materia) && self.tieneAprobadaCorrelativasDe(materia) 
    }

    method estaEnCarreraCon(materia) {
        return not carrera.isEmpty() && self.tieneCarreraCon(materia)
    }

    method tieneCarreraCon(materia) {
        return self.materiasDeCarrera().any({materia => materia == materia})
    }

}
const roque = new Estudiante(nombre = "Roque")

class Aprobacion {
  
    var materia
    var nota 

    method materia() = materia

    method nota() = nota

}