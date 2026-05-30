import Foundation

//Enums

enum NivelExperiencia {
    case iniciante
    case intermediario
    case avancado
}

enum CategoriaAula {
    case musculacao
    case spinning
    case yoga
    case funcional
    case luta
}

//Plano de Assinatura

struct PlanoAssinatura {
    let nome: String
    let mensalidade: Double
    let incluiPersonal: Bool
    let limiteAulasColetivas: Int
    let duracaoMeses: Int
}

// Catálogo de planos
let planoMensal = PlanoAssinatura(
    nome: "Mensal",
    mensalidade: 99.90,
    incluiPersonal: false,
    limiteAulasColetivas: 8,
    duracaoMeses: 1
)

let planoTrimestral = PlanoAssinatura(
    nome: "Trimestral",
    mensalidade: 79.90,
    incluiPersonal: false,
    limiteAulasColetivas: 12,
    duracaoMeses: 3
)

let planoAnual = PlanoAssinatura(
    nome: "Anual",
    mensalidade: 59.90,
    incluiPersonal: true,
    limiteAulasColetivas: 20,
    duracaoMeses: 12
)

let catalogoPlanos: [PlanoAssinatura] = [planoMensal, planoTrimestral, planoAnual]

//Hierarquia de Pessoas

class Pessoa {
    let nome: String
    let email: String
    let telefone: String
    let cpf: String
    var endereco: String

    init(nome: String, email: String, telefone: String, cpf: String, endereco: String) {
        self.nome = nome
        self.email = email
        self.telefone = telefone
        self.cpf = cpf
        self.endereco = endereco
    }

    func descricao() -> String {
        return "Pessoa: \(nome) | Email: \(email) | Telefone: \(telefone)"
    }
}

class Aluno: Pessoa {
    let matricula: String
    var plano: PlanoAssinatura
    var nivel: NivelExperiencia
    var frequenciaSemanal: Int      // dias por semana que costuma treinar
    var pesoKg: Double              // peso atual em kg
    var alturaMetros: Double        // altura em metros
    var objetivoTreino: String      // ex: "Ganho de massa", "Emagrecimento"
    var possuiAtestadoMedico: Bool  // exigência comum em academias

    init(
        nome: String,
        email: String,
        telefone: String,
        cpf: String,
        endereco: String,
        matricula: String,
        plano: PlanoAssinatura,
        nivel: NivelExperiencia,
        frequenciaSemanal: Int,
        pesoKg: Double,
        alturaMetros: Double,
        objetivoTreino: String,
        possuiAtestadoMedico: Bool
    ) {
        self.matricula = matricula
        self.plano = plano
        self.nivel = nivel
        self.frequenciaSemanal = frequenciaSemanal
        self.pesoKg = pesoKg
        self.alturaMetros = alturaMetros
        self.objetivoTreino = objetivoTreino
        self.possuiAtestadoMedico = possuiAtestadoMedico
        super.init(nome: nome, email: email, telefone: telefone, cpf: cpf, endereco: endereco)
    }

    func atualizarPlano(novoPlano: PlanoAssinatura) {
        plano = novoPlano
        print("Plano de \(nome) atualizado para: \(novoPlano.nome)")
    }

    func atualizarNivel(novoNivel: NivelExperiencia) {
        nivel = novoNivel
        print("Nível de \(nome) atualizado.")
    }

    override func descricao() -> String {
        return "Aluno: \(nome) | Matrícula: \(matricula) | Plano: \(plano.nome) | Objetivo: \(objetivoTreino)"
    }
}

class Instrutor: Pessoa {
    let especialidade: CategoriaAula
    let anoIngresso: Int        // ano em que começou na academia
    let cref: String            // registro profissional de educação física
    var salario: Double
    var disponibilidadeSemanal: Int  // quantos dias por semana está disponível

    init(
        nome: String,
        email: String,
        telefone: String,
        cpf: String,
        endereco: String,
        especialidade: CategoriaAula,
        anoIngresso: Int,
        cref: String,
        salario: Double,
        disponibilidadeSemanal: Int
    ) {
        self.especialidade = especialidade
        self.anoIngresso = anoIngresso
        self.cref = cref
        self.salario = salario
        self.disponibilidadeSemanal = disponibilidadeSemanal
        super.init(nome: nome, email: email, telefone: telefone, cpf: cpf, endereco: endereco)
    }

    override func descricao() -> String {
        return "Instrutor: \(nome) | CREF: \(cref) | Telefone: \(telefone)"
    }
}

//Testes

let aluno1 = Aluno(
    nome: "Carlos Mendes",
    email: "carlos@email.com",
    telefone: "11999990001",
    cpf: "123.456.789-00",
    endereco: "Rua das Flores, 42 - São Paulo",
    matricula: "ACM-001",
    plano: planoMensal,
    nivel: .iniciante,
    frequenciaSemanal: 3,
    pesoKg: 82.5,
    alturaMetros: 1.78,
    objetivoTreino: "Ganho de massa",
    possuiAtestadoMedico: true
)

let instrutor1 = Instrutor(
    nome: "Fernanda Lima",
    email: "fernanda@academia.com",
    telefone: "11988880001",
    cpf: "987.654.321-00",
    endereco: "Av. Paulista, 900 - São Paulo",
    especialidade: .yoga,
    anoIngresso: 2019,
    cref: "012345-G/SP",
    salario: 3800.00,
    disponibilidadeSemanal: 5
)

print(aluno1.descricao())
print(instrutor1.descricao())

aluno1.atualizarPlano(novoPlano: planoAnual)
aluno1.atualizarNivel(novoNivel: .intermediario)

print(aluno1.descricao())
