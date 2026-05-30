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

let planoMensal     = PlanoAssinatura(nome: "Mensal",     mensalidade: 99.90, incluiPersonal: false, limiteAulasColetivas: 8,  duracaoMeses: 1)
let planoTrimestral = PlanoAssinatura(nome: "Trimestral", mensalidade: 79.90, incluiPersonal: false, limiteAulasColetivas: 12, duracaoMeses: 3)
let planoAnual      = PlanoAssinatura(nome: "Anual",      mensalidade: 59.90, incluiPersonal: true,  limiteAulasColetivas: 20, duracaoMeses: 12)

class Pessoa {
    let nome: String
    let email: String
    let telefone: String
    let cpf: String
    var endereco: String

    init(nome: String, email: String, telefone: String, cpf: String, endereco: String) {
        self.nome = nome; self.email = email; self.telefone = telefone
        self.cpf = cpf; self.endereco = endereco
    }

    func descricao() -> String { return "Pessoa: \(nome) | Email: \(email)" }
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
        self.matricula = matricula; self.plano = plano; self.nivel = nivel
        self.frequenciaSemanal = frequenciaSemanal; self.pesoKg = pesoKg
        self.alturaMetros = alturaMetros; self.objetivoTreino = objetivoTreino
        self.possuiAtestadoMedico = possuiAtestadoMedico
        super.init(nome: nome, email: email, telefone: telefone, cpf: cpf, endereco: endereco)
    }

    func atualizarPlano(novoPlano: PlanoAssinatura) { plano = novoPlano }
    func atualizarNivel(novoNivel: NivelExperiencia) { nivel = novoNivel }

    override func descricao() -> String {
        return "Aluno: \(nome) | Matrícula: \(matricula) | Plano: \(plano.nome)"
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
        self.especialidade = especialidade; self.anoIngresso = anoIngresso
        self.cref = cref; self.salario = salario
        self.disponibilidadeSemanal = disponibilidadeSemanal
        super.init(nome: nome, email: email, telefone: telefone, cpf: cpf, endereco: endereco)
    }

    override func descricao() -> String {
        return "Instrutor: \(nome) | CREF: \(cref)"
    }
}

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
        self.nomeItem = nomeItem; self.numeroSerie = numeroSerie
        self.anoAquisicao = anoAquisicao; self.estadoAtual = estadoAtual
        self.localizacaoNaSala = localizacaoNaSala
    }

    func realizarReparo(data: String, descricao: String) -> StatusManutencao {
        if estadoAtual == .defeituoso {
            let registro = RegistroReparo(data: data, status: .irregular, descricao: "FALHA: \(descricao)")
            historicoReparos.append(registro)
            return .irregular
        }
        let registro = RegistroReparo(data: data, status: .regular, descricao: descricao)
        historicoReparos.append(registro)
        return .regular
    }
}

protocol Aula {
    var nomeAula: String { get }
    var instrutor: Instrutor { get }
    var categoria: CategoriaAula { get }
    var descricao: String { get }
}

class TurmaColetiva: Aula {
    let nomeAula: String
    let instrutor: Instrutor
    let categoria: CategoriaAula
    let descricao: String
    let horario: String
    let capacidadeMaxima: Int
    let capacidadeMinima: Int
    private(set) var alunosInscritos: [Aluno] = []

    var vagasDisponiveis: Int { return capacidadeMaxima - alunosInscritos.count }

    init(nomeAula: String, instrutor: Instrutor, categoria: CategoriaAula,
         descricao: String, horario: String, capacidadeMaxima: Int, capacidadeMinima: Int) {
        self.nomeAula = nomeAula; self.instrutor = instrutor; self.categoria = categoria
        self.descricao = descricao; self.horario = horario
        self.capacidadeMaxima = capacidadeMaxima; self.capacidadeMinima = capacidadeMinima
    }

    func inscreverAluno(aluno: Aluno) {
        guard !alunosInscritos.contains(where: { $0.matricula == aluno.matricula }) else {
            print("\(aluno.nome) já está inscrito em '\(nomeAula)'.")
            return
        }
        guard vagasDisponiveis > 0 else {
            print("Sem vagas em '\(nomeAula)'. \(aluno.nome) não foi inscrito.")
            return
        }
        alunosInscritos.append(aluno)
        print("\(aluno.nome) inscrito em '\(nomeAula)'. Vagas restantes: \(vagasDisponiveis).")
    }

    func removerAluno(aluno: Aluno) {
        guard alunosInscritos.contains(where: { $0.matricula == aluno.matricula }) else {
            print("\(aluno.nome) não está inscrito em '\(nomeAula)'.")
            return
        }
        alunosInscritos.removeAll { $0.matricula == aluno.matricula }
        print("\(aluno.nome) removido de '\(nomeAula)'.")
    }
}

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
        self.nomeAula = nomeAula; self.instrutor = instrutor; self.categoria = categoria
        self.descricao = descricao; self.aluno = aluno; self.duracaoMinutos = duracaoMinutos
        self.valorSessao = valorSessao; self.observacoesSaude = observacoesSaude
    }
}

class Academia {
    let nomeFantasia: String
    let cnpj: String
    let endereco: String
    let telefoneContato: String

    //Dicionários
    private(set) var alunos: [String: Aluno] = [:]          
    private(set) var instrutores: [String: Instrutor] = [:] 
    private(set) var equipamentos: [String: Equipamento] = [:] 
    private(set) var turmasColetivas: [String: TurmaColetiva] = [:] 
    private(set) var sessoesPersonal: [TreinoPersonal] = []

    init(nomeFantasia: String, cnpj: String, endereco: String, telefoneContato: String) {
        self.nomeFantasia = nomeFantasia
        self.cnpj = cnpj
        self.endereco = endereco
        self.telefoneContato = telefoneContato
    }

    //Admissão de Alunos

    func cadastrarAluno(aluno: Aluno) {
        guard alunos[aluno.matricula] == nil else {
            print("Matrícula '\(aluno.matricula)' já cadastrada.")
            return
        }

        let emailDuplicado = alunos.values.contains { $0.email == aluno.email }
        guard !emailDuplicado else {
            print("E-mail '\(aluno.email)' já está em uso por outro aluno.")
            return
        }

        alunos[aluno.matricula] = aluno
        print("Aluno '\(aluno.nome)' cadastrado com matrícula \(aluno.matricula).")
    }

    //Admissão de Instrutores

    func cadastrarInstrutor(instrutor: Instrutor) {
        guard instrutores[instrutor.cref] == nil else {
            print("CREF '\(instrutor.cref)' já cadastrado.")
            return
        }

        let emailDuplicado = instrutores.values.contains { $0.email == instrutor.email }
        guard !emailDuplicado else {
            print("Email '\(instrutor.email)' já está em uso por outro instrutor.")
            return
        }

        instrutores[instrutor.cref] = instrutor
        print("Instrutor '\(instrutor.nome)' cadastrado com CREF \(instrutor.cref).")
    }

    //Cadastro de Equipamentos

    func cadastrarEquipamento(equipamento: Equipamento) {
        guard equipamentos[equipamento.numeroSerie] == nil else {
            print("Equipamento com série '\(equipamento.numeroSerie)' já cadastrado.")
            return
        }
        equipamentos[equipamento.numeroSerie] = equipamento
        print("Equipamento '\(equipamento.nomeItem)' cadastrado.")
    }

    //Cadastro de Turmas Coletivas

    func cadastrarTurma(turma: TurmaColetiva) {
        guard turmasColetivas[turma.nomeAula] == nil else {
            print("Turma '\(turma.nomeAula)' já cadastrada.")
            return
        }
        turmasColetivas[turma.nomeAula] = turma
        print("Turma '\(turma.nomeAula)' cadastrada.")
    }

    // MARK: Manutenção em Lote

    func executarManutencaoLote(data: String, descricao: String) {
        print("\nIniciando manutenção em lote — \(data)")
        var equipamentosComFalha: [Equipamento] = []

        for equipamento in equipamentos.values {
            let resultado = equipamento.realizarReparo(data: data, descricao: descricao)
            if resultado == .irregular {
                equipamentosComFalha.append(equipamento)
            }
        }

        if equipamentosComFalha.isEmpty {
            print("Todos os equipamentos passaram na manutenção.")
        } else {
            print("\nEquipamentos com falha (\(equipamentosComFalha.count)):")
            for item in equipamentosComFalha {
                print("\(item.nomeItem) | Série: \(item.numeroSerie) | Local: \(item.localizacaoNaSala)")
            }
        }
    }

    //Agendamento de Personal 

    func agendarSessaoPersonal(
        aluno: Aluno,
        instrutor: Instrutor,
        categoria: CategoriaAula,
        data: String,
        duracaoMinutos: Int,
        valorSessao: Double,
        observacoesSaude: String
    ) {
        guard aluno.plano.incluiPersonal else {
            print("Agendamento negado: o plano '\(aluno.plano.nome)' de \(aluno.nome) não inclui personal trainer.")
            return
        }

        guard instrutores[instrutor.cref] != nil else {
            print("Agendamento negado: instrutor '\(instrutor.nome)' não está cadastrado na academia.")
            return
        }

        guard alunos[aluno.matricula] != nil else {
            print("Agendamento negado: aluno '\(aluno.nome)' não está cadastrado na academia.")
            return
        }

        let sessao = TreinoPersonal(
            nomeAula: "Personal — \(aluno.nome) com \(instrutor.nome)",
            instrutor: instrutor,
            categoria: categoria,
            descricao: "Sessão agendada para \(data)",
            aluno: aluno,
            duracaoMinutos: duracaoMinutos,
            valorSessao: valorSessao,
            observacoesSaude: observacoesSaude
        )

        sessoesPersonal.append(sessao)
        print("Sessão de personal agendada para \(aluno.nome) com \(instrutor.nome) em \(data).")
    }

    //Relatório Geral

    func exibirResumo() {
        print("\nResumo da Academia: \(nomeFantasia)")
        print("Alunos cadastrados   : \(alunos.count)")
        print("Instrutores          : \(instrutores.count)")
        print("Equipamentos         : \(equipamentos.count)")
        print("Turmas coletivas     : \(turmasColetivas.count)")
        print("Sessões de personal  : \(sessoesPersonal.count)")
    }
}

let academia = Academia(
    nomeFantasia: "AcademiaFit",
    cnpj: "12.345.678/0001-99",
    endereco: "Av. Brasil, 500 - São Paulo",
    telefoneContato: "1133330000"
)

//Instrutores
let instrutora = Instrutor(
    nome: "Fernanda Lima", email: "fernanda@academia.com", telefone: "11988880001",
    cpf: "987.654.321-00", endereco: "Av. Paulista, 900",
    especialidade: .yoga, anoIngresso: 2019, cref: "012345-G/SP",
    salario: 3800.00, disponibilidadeSemanal: 5
)
let instrutorMusc = Instrutor(
    nome: "Rafael Torres", email: "rafael@academia.com", telefone: "11977770099",
    cpf: "111.222.333-44", endereco: "Rua Norte, 88",
    especialidade: .musculacao, anoIngresso: 2021, cref: "054321-G/SP",
    salario: 4200.00, disponibilidadeSemanal: 5
)

academia.cadastrarInstrutor(instrutor: instrutora)
academia.cadastrarInstrutor(instrutor: instrutorMusc)
academia.cadastrarInstrutor(instrutor: instrutora) 

//Alunos
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
let alunoDuplicado = Aluno(
    nome: "Carlos Clone", email: "carlos@email.com", telefone: "11000000000",
    cpf: "000.000.000-00", endereco: "Rua X", matricula: "ACM-001",
    plano: planoMensal, nivel: .iniciante, frequenciaSemanal: 2,
    pesoKg: 70.0, alturaMetros: 1.70, objetivoTreino: "Emagrecimento",
    possuiAtestadoMedico: false
)

academia.cadastrarAluno(aluno: aluno1)
academia.cadastrarAluno(aluno: aluno2)
academia.cadastrarAluno(aluno: alunoDuplicado) 
academia.cadastrarAluno(aluno: alunoDuplicado) 

//Equipamentos
let esteira = Equipamento(nomeItem: "Esteira Speedo", numeroSerie: "SN-4821",
    anoAquisicao: 2021, estadoAtual: .emFuncionamento, localizacaoNaSala: "Cardio - P1")
let bike = Equipamento(nomeItem: "Bike Spinning Pro", numeroSerie: "SN-1100",
    anoAquisicao: 2020, estadoAtual: .emFuncionamento, localizacaoNaSala: "Spinning - P4")
let haltere = Equipamento(nomeItem: "Halter 20kg", numeroSerie: "SN-0033",
    anoAquisicao: 2018, estadoAtual: .defeituoso, localizacaoNaSala: "Musculação - Rack 2")

academia.cadastrarEquipamento(equipamento: esteira)
academia.cadastrarEquipamento(equipamento: bike)
academia.cadastrarEquipamento(equipamento: haltere)

//Manutenção em lote
academia.executarManutencaoLote(data: "2025-06-10", descricao: "Revisão mensal padrão")

//Turma coletiva
let turmaYoga = TurmaColetiva(
    nomeAula: "Yoga Matinal", instrutor: instrutora, categoria: .yoga,
    descricao: "Yoga com foco em respiração.", horario: "Seg e Qua - 07:00",
    capacidadeMaxima: 10, capacidadeMinima: 3
)
academia.cadastrarTurma(turma: turmaYoga)
turmaYoga.inscreverAluno(aluno: aluno1)
turmaYoga.inscreverAluno(aluno: aluno2)

//Agendamento de personal
print("\nTentativas de Agendamento de Personal")
academia.agendarSessaoPersonal(  
    aluno: aluno1, instrutor: instrutorMusc, categoria: .musculacao,
    data: "2025-06-15", duracaoMinutos: 60, valorSessao: 120.00,
    observacoesSaude: "Sem restrições."
)
academia.agendarSessaoPersonal(  
    aluno: aluno2, instrutor: instrutorMusc, categoria: .musculacao,
    data: "2025-06-15", duracaoMinutos: 60, valorSessao: 120.00,
    observacoesSaude: "Sem restrições."
)

//"main"
academia.exibirResumo()
