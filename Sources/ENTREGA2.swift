import Foundation

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

struct PlanoAssinatura {
    let nome: String
    let mensalidade: Double
    let incluiPersonal: Bool
    let limiteAulasColetivas: Int
    let duracaoMeses: Int
}

let planoMensal = PlanoAssinatura(nome: "Mensal", mensalidade: 99.90, incluiPersonal: false, limiteAulasColetivas: 8, duracaoMeses: 1)
let planoTrimestral = PlanoAssinatura(nome: "Trimestral", mensalidade: 79.90, incluiPersonal: false, limiteAulasColetivas: 12, duracaoMeses: 3)
let planoAnual = PlanoAssinatura(nome: "Anual", mensalidade: 59.90, incluiPersonal: true, limiteAulasColetivas: 20, duracaoMeses: 12)

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
    var frequenciaSemanal: Int
    var pesoKg: Double
    var alturaMetros: Double
    var objetivoTreino: String
    var possuiAtestadoMedico: Bool

    init(nome: String, email: String, telefone: String, cpf: String, endereco: String,
         matricula: String, plano: PlanoAssinatura, nivel: NivelExperiencia,
         frequenciaSemanal: Int, pesoKg: Double, alturaMetros: Double,
         objetivoTreino: String, possuiAtestadoMedico: Bool) {
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
    let anoIngresso: Int
    let cref: String
    var salario: Double
    var disponibilidadeSemanal: Int

    init(nome: String, email: String, telefone: String, cpf: String, endereco: String,
         especialidade: CategoriaAula, anoIngresso: Int, cref: String,
         salario: Double, disponibilidadeSemanal: Int) {
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

//Protocolo de Manutenção

enum StatusManutencao {
    case regular
    case irregular
}

struct RegistroReparo {
    let data: String
    let status: StatusManutencao
    let descricao: String
}

protocol Manutivel {
    var nomeItem: String { get }
    var historicoReparos: [RegistroReparo] { get }

    func realizarReparo(data: String, descricao: String) -> StatusManutencao
}

//Equipamento Físico

enum EstadoEquipamento {
    case emFuncionamento
    case defeituoso
}

class Equipamento: Manutivel {
    let nomeItem: String
    let numeroSerie: String         
    let anoAquisicao: Int            
    var estadoAtual: EstadoEquipamento
    var localizacaoNaSala: String    
    private(set) var historicoReparos: [RegistroReparo] = []

    init(nomeItem: String, numeroSerie: String, anoAquisicao: Int,
         estadoAtual: EstadoEquipamento, localizacaoNaSala: String) {
        self.nomeItem = nomeItem
        self.numeroSerie = numeroSerie
        self.anoAquisicao = anoAquisicao
        self.estadoAtual = estadoAtual
        self.localizacaoNaSala = localizacaoNaSala
    }

    func realizarReparo(data: String, descricao: String) -> StatusManutencao {
        if estadoAtual == .defeituoso {
            let registro = RegistroReparo(data: data, status: .irregular, descricao: "FALHA: equipamento defeituoso — \(descricao)")
            historicoReparos.append(registro)
            print("Manutenção de '\(nomeItem)' falhou: equipamento está defeituoso e fora de operação.")
            return .irregular
        }

        let registro = RegistroReparo(data: data, status: .regular, descricao: descricao)
        historicoReparos.append(registro)
        print("Manutenção de '\(nomeItem)' registrada com sucesso em \(data).")
        return .regular
    }
}

//Protocolo Base de Aula

protocol Aula {
    var nomeAula: String { get }
    var instrutor: Instrutor { get }
    var categoria: CategoriaAula { get }
    var descricao: String { get }
}

//Turma Coletiva

class TurmaColetiva: Aula {
    let nomeAula: String
    let instrutor: Instrutor
    let categoria: CategoriaAula
    let descricao: String
    let horario: String             
    let capacidadeMaxima: Int
    let capacidadeMinima: Int       
    private(set) var alunosInscritos: [Aluno] = []

    var vagasDisponiveis: Int {
        return capacidadeMaxima - alunosInscritos.count
    }

    init(nomeAula: String, instrutor: Instrutor, categoria: CategoriaAula,
         descricao: String, horario: String, capacidadeMaxima: Int, capacidadeMinima: Int) {
        self.nomeAula = nomeAula
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.horario = horario
        self.capacidadeMaxima = capacidadeMaxima
        self.capacidadeMinima = capacidadeMinima
    }

    func inscreverAluno(aluno: Aluno) {
        let jaInscrito = alunosInscritos.contains { $0.matricula == aluno.matricula }

        if jaInscrito {
            print("\(aluno.nome) já está inscrito em '\(nomeAula)'.")
            return
        }

        if vagasDisponiveis == 0 {
            print("Sem vagas em '\(nomeAula)'. \(aluno.nome) não foi inscrito.")
            return
        }

        alunosInscritos.append(aluno)
        print("\(aluno.nome) inscrito em '\(nomeAula)'. Vagas restantes: \(vagasDisponiveis).")
    }

    func removerAluno(aluno: Aluno) {
        let jaInscrito = alunosInscritos.contains { $0.matricula == aluno.matricula }

        if !jaInscrito {
            print("\(aluno.nome) não está inscrito em '\(nomeAula)'.")
            return
        }

        alunosInscritos.removeAll { $0.matricula == aluno.matricula }
        print("\(aluno.nome) removido de '\(nomeAula)'.")
    }
}

//Treino com Personal

class TreinoPersonal: Aula {
    let nomeAula: String
    let instrutor: Instrutor
    let categoria: CategoriaAula
    let descricao: String
    let aluno: Aluno
    let duracaoMinutos: Int         
    let valorSessao: Double         
    var observacoesSaude: String    

    init(nomeAula: String, instrutor: Instrutor, categoria: CategoriaAula,
         descricao: String, aluno: Aluno, duracaoMinutos: Int,
         valorSessao: Double, observacoesSaude: String) {
        self.nomeAula = nomeAula
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.aluno = aluno
        self.duracaoMinutos = duracaoMinutos
        self.valorSessao = valorSessao
        self.observacoesSaude = observacoesSaude
    }
}

//TESTES

//Equipamentos
let esteira = Equipamento(
    nomeItem: "Esteira Speedo",
    numeroSerie: "SN-4821",
    anoAquisicao: 2021,
    estadoAtual: .emFuncionamento,
    localizacaoNaSala: "Setor Cardio - Posição 1"
)

let haltere = Equipamento(
    nomeItem: "Halter 20kg",
    numeroSerie: "SN-0033",
    anoAquisicao: 2018,
    estadoAtual: .defeituoso,
    localizacaoNaSala: "Setor Musculação - Rack 2"
)

esteira.realizarReparo(data: "2025-06-01", descricao: "Lubrificação da correia")
haltere.realizarReparo(data: "2025-06-01", descricao: "Verificação de solda")

//Instrutor e Alunos 
let instrutora = Instrutor(
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

let aluno1 = Aluno(
    nome: "Carlos Mendes", email: "carlos@email.com", telefone: "11999990001",
    cpf: "123.456.789-00", endereco: "Rua das Flores, 42", matricula: "ACM-001",
    plano: planoAnual, nivel: .iniciante, frequenciaSemanal: 3,
    pesoKg: 82.5, alturaMetros: 1.78, objetivoTreino: "Ganho de massa",
    possuiAtestadoMedico: true
)

let aluno2 = Aluno(
    nome: "Beatriz Santos", email: "bea@email.com", telefone: "11977770002",
    cpf: "321.654.987-00", endereco: "Rua Verde, 10", matricula: "ACM-002",
    plano: planoMensal, nivel: .intermediario, frequenciaSemanal: 4,
    pesoKg: 61.0, alturaMetros: 1.65, objetivoTreino: "Flexibilidade",
    possuiAtestadoMedico: true
)

//Turma Coletiva 
let turmaYoga = TurmaColetiva(
    nomeAula: "Yoga Matinal",
    instrutor: instrutora,
    categoria: .yoga,
    descricao: "Aula de yoga com foco em respiração e alongamento.",
    horario: "Segunda e Quarta - 07:00",
    capacidadeMaxima: 2,
    capacidadeMinima: 1
)

turmaYoga.inscreverAluno(aluno: aluno1)
turmaYoga.inscreverAluno(aluno: aluno2)
turmaYoga.inscreverAluno(aluno: aluno1) 
turmaYoga.inscreverAluno(aluno: aluno2) 

//Treino Personal
let sessaoPersonal = TreinoPersonal(
    nomeAula: "Treino Funcional Personalizado",
    instrutor: instrutora,
    categoria: .funcional,
    descricao: "Sessão individualizada de treino funcional.",
    aluno: aluno1,
    duracaoMinutos: 60,
    valorSessao: 120.00,
    observacoesSaude: "Aluno com leve dor lombar — evitar agachamento profundo."
)

print("\n--- Sessão Personal ---")
print("Aluno: \(sessaoPersonal.aluno.nome) | Duração: \(sessaoPersonal.duracaoMinutos) min | Valor: R$ \(sessaoPersonal.valorSessao)")
print("Obs: \(sessaoPersonal.observacoesSaude)")
