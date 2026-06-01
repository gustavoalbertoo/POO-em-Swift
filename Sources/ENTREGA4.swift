import Foundation

//ENUMS, STRUCTS E HIERARQUIA DE PESSOAS

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

    func descricao() -> String {
        return "Pessoa: \(nome) | Email: \(email)"
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
        return "Instrutor: \(nome) | CREF: \(cref) | Especialidade: \(especialidade)"
    }
}

//PROTOCOLOS, EQUIPAMENTOS E AULAS

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
            print("Turma '\(nomeAula)' lotada. \(aluno.nome) não foi inscrito.")
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

//GERENCIADOR CENTRAL

class Academia {
    let nomeFantasia: String
    let cnpj: String
    let endereco: String
    let telefoneContato: String

    private(set) var alunos: [String: Aluno] = [:]
    private(set) var instrutores: [String: Instrutor] = [:]
    private(set) var equipamentos: [String: Equipamento] = [:]
    private(set) var turmasColetivas: [String: TurmaColetiva] = [:]
    private(set) var sessoesPersonal: [TreinoPersonal] = []

    init(nomeFantasia: String, cnpj: String, endereco: String, telefoneContato: String) {
        self.nomeFantasia = nomeFantasia; self.cnpj = cnpj
        self.endereco = endereco; self.telefoneContato = telefoneContato
    }

    func cadastrarAluno(aluno: Aluno) {
        guard alunos[aluno.matricula] == nil else {
            print("Matrícula '\(aluno.matricula)' já cadastrada.")
            return
        }
        guard !alunos.values.contains(where: { $0.email == aluno.email }) else {
            print("E-mail '\(aluno.email)' já está em uso.")
            return
        }
        alunos[aluno.matricula] = aluno
        print("Aluno '\(aluno.nome)' cadastrado.")
    }

    func cadastrarInstrutor(instrutor: Instrutor) {
        guard instrutores[instrutor.cref] == nil else {
            print("CREF '\(instrutor.cref)' já cadastrado.")
            return
        }
        guard !instrutores.values.contains(where: { $0.email == instrutor.email }) else {
            print("E-mail '\(instrutor.email)' já está em uso.")
            return
        }
        instrutores[instrutor.cref] = instrutor
        print("Instrutor '\(instrutor.nome)' cadastrado.")
    }

    func cadastrarEquipamento(equipamento: Equipamento) {
        guard equipamentos[equipamento.numeroSerie] == nil else {
            print("Equipamento série '\(equipamento.numeroSerie)' já cadastrado.")
            return
        }
        equipamentos[equipamento.numeroSerie] = equipamento
        print("Equipamento '\(equipamento.nomeItem)' cadastrado.")
    }

    func cadastrarTurma(turma: TurmaColetiva) {
        guard turmasColetivas[turma.nomeAula] == nil else {
            print("Turma '\(turma.nomeAula)' já cadastrada.")
            return
        }
        turmasColetivas[turma.nomeAula] = turma
        print("Turma '\(turma.nomeAula)' cadastrada.")
    }

    func executarManutencaoLote(data: String, descricao: String) {
        print("\n🔧 Manutenção em lote — \(data)")
        var falhas: [Equipamento] = []
        for equipamento in equipamentos.values {
            let resultado = equipamento.realizarReparo(data: data, descricao: descricao)
            if resultado == .irregular {
                falhas.append(equipamento)
            }
        }
        if falhas.isEmpty {
            print("Todos os equipamentos passaram na manutenção.")
        } else {
            print("Equipamentos com falha (\(falhas.count)):")
            for item in falhas {
                print("   • \(item.nomeItem) | Série: \(item.numeroSerie) | Local: \(item.localizacaoNaSala)")
            }
        }
    }

    func agendarSessaoPersonal(aluno: Aluno, instrutor: Instrutor, categoria: CategoriaAula,
                                data: String, duracaoMinutos: Int, valorSessao: Double,
                                observacoesSaude: String) {
        guard aluno.plano.incluiPersonal else {
            print("Plano '\(aluno.plano.nome)' de \(aluno.nome) não inclui personal.")
            return
        }
        guard instrutores[instrutor.cref] != nil else {
            print("Instrutor '\(instrutor.nome)' não cadastrado.")
            return
        }
        guard alunos[aluno.matricula] != nil else {
            print("Aluno '\(aluno.nome)' não cadastrado.")
            return
        }
        let sessao = TreinoPersonal(
            nomeAula: "Personal — \(aluno.nome) com \(instrutor.nome)",
            instrutor: instrutor, categoria: categoria,
            descricao: "Sessão em \(data)", aluno: aluno,
            duracaoMinutos: duracaoMinutos, valorSessao: valorSessao,
            observacoesSaude: observacoesSaude
        )
        sessoesPersonal.append(sessao)
        print("Personal agendado: \(aluno.nome) com \(instrutor.nome) em \(data).")
    }
}

//EXTENSÃO DE MÉTRICAS

struct RelatorioMetricas {
    let totalAlunos: Int
    let totalInstrutores: Int
    let totalAulasAtivas: Int
    let totalEquipamentosDefeituosos: Int
    let totalSessoesPersonal: Int
    let receitaMensalEstimada: Double
}

extension Academia {
    func gerarRelatorioMetricas() -> RelatorioMetricas {
        let totalAulas = turmasColetivas.count + sessoesPersonal.count
        let defeituosos = equipamentos.values.filter { $0.estadoAtual == .defeituoso }.count
        let receita = alunos.values.reduce(0.0) { $0 + $1.plano.mensalidade }

        return RelatorioMetricas(
            totalAlunos: alunos.count,
            totalInstrutores: instrutores.count,
            totalAulasAtivas: totalAulas,
            totalEquipamentosDefeituosos: defeituosos,
            totalSessoesPersonal: sessoesPersonal.count,
            receitaMensalEstimada: receita
        )
    }

    func exibirRelatorio() {
        let m = gerarRelatorioMetricas()
        print("""
        Relatório de Métricas: \(nomeFantasia)
        Alunos cadastrados         : \(m.totalAlunos)
        Instrutores                : \(m.totalInstrutores)
        Aulas ativas (turmas+PTs)  : \(m.totalAulasAtivas)
        Sessões de personal        : \(m.totalSessoesPersonal)
        Equipamentos defeituosos   : \(m.totalEquipamentosDefeituosos)
        Receita mensal estimada    : R$ \(m.receitaMensalEstimada)
        """)
    }
}

//FINAL

print("SISTEMA ACADEMIA")

let academia = Academia(
    nomeFantasia: "AcademiaFit",
    cnpj: "12.345.678/0001-99",
    endereco: "Av. Brasil, 500 - São Paulo",
    telefoneContato: "1133330000"
)

print("\n--- Cadastro de Instrutores ---")
let fernanda = Instrutor(
    nome: "Fernanda Lima", email: "fernanda@fit.com", telefone: "11988880001",
    cpf: "987.654.321-00", endereco: "Av. Paulista, 900",
    especialidade: .yoga, anoIngresso: 2019, cref: "012345-G/SP",
    salario: 3800.00, disponibilidadeSemanal: 5
)
let rafael = Instrutor(
    nome: "Rafael Torres", email: "rafael@fit.com", telefone: "11977770099",
    cpf: "111.222.333-44", endereco: "Rua Norte, 88",
    especialidade: .musculacao, anoIngresso: 2021, cref: "054321-G/SP",
    salario: 4200.00, disponibilidadeSemanal: 5
)
let joao = Instrutor(
    nome: "João Melo", email: "joao@fit.com", telefone: "11966660033",
    cpf: "555.666.777-88", endereco: "Rua Leste, 12",
    especialidade: .luta, anoIngresso: 2022, cref: "099887-G/SP",
    salario: 3500.00, disponibilidadeSemanal: 4
)

academia.cadastrarInstrutor(instrutor: fernanda)
academia.cadastrarInstrutor(instrutor: rafael)
academia.cadastrarInstrutor(instrutor: joao)

print("\n-- Barreira: CREF duplicado --")
academia.cadastrarInstrutor(instrutor: fernanda)

let instrutorEmailRepetido = Instrutor(
    nome: "Clone Silva", email: "rafael@fit.com", telefone: "11000000000",
    cpf: "000.111.222-33", endereco: "Rua X", especialidade: .spinning,
    anoIngresso: 2023, cref: "111111-G/SP", salario: 3000.00, disponibilidadeSemanal: 3
)
academia.cadastrarInstrutor(instrutor: instrutorEmailRepetido)

print("\n--- Cadastro de Alunos ---")
let carlos = Aluno(
    nome: "Carlos Mendes", email: "carlos@email.com", telefone: "11999990001",
    cpf: "123.456.789-00", endereco: "Rua das Flores, 42", matricula: "ACM-001",
    plano: planoAnual, nivel: .intermediario, frequenciaSemanal: 4,
    pesoKg: 82.5, alturaMetros: 1.78, objetivoTreino: "Ganho de massa",
    possuiAtestadoMedico: true
)
let beatriz = Aluno(
    nome: "Beatriz Santos", email: "bea@email.com", telefone: "11977770002",
    cpf: "321.654.987-00", endereco: "Rua Verde, 10", matricula: "ACM-002",
    plano: planoMensal, nivel: .iniciante, frequenciaSemanal: 3,
    pesoKg: 61.0, alturaMetros: 1.65, objetivoTreino: "Emagrecimento",
    possuiAtestadoMedico: true
)
let lucas = Aluno(
    nome: "Lucas Prado", email: "lucas@email.com", telefone: "11955550003",
    cpf: "444.555.666-77", endereco: "Av. Central, 200", matricula: "ACM-003",
    plano: planoTrimestral, nivel: .avancado, frequenciaSemanal: 5,
    pesoKg: 75.0, alturaMetros: 1.80, objetivoTreino: "Condicionamento",
    possuiAtestadoMedico: true
)
let ana = Aluno(
    nome: "Ana Ferreira", email: "ana@email.com", telefone: "11944440004",
    cpf: "888.999.000-11", endereco: "Rua Sul, 77", matricula: "ACM-004",
    plano: planoAnual, nivel: .iniciante, frequenciaSemanal: 2,
    pesoKg: 55.0, alturaMetros: 1.60, objetivoTreino: "Flexibilidade",
    possuiAtestadoMedico: false
)

academia.cadastrarAluno(aluno: carlos)
academia.cadastrarAluno(aluno: beatriz)
academia.cadastrarAluno(aluno: lucas)
academia.cadastrarAluno(aluno: ana)

print("\n-- Barreira: matrícula duplicada --")
let alunoMatriculaRepetida = Aluno(
    nome: "Pedro Clone", email: "pedro@email.com", telefone: "11000000001",
    cpf: "000.000.001-00", endereco: "Rua Y", matricula: "ACM-001",
    plano: planoMensal, nivel: .iniciante, frequenciaSemanal: 2,
    pesoKg: 70.0, alturaMetros: 1.72, objetivoTreino: "Saúde",
    possuiAtestadoMedico: true
)
academia.cadastrarAluno(aluno: alunoMatriculaRepetida)

print("\n-- Barreira: e-mail duplicado --")
let alunoEmailRepetido = Aluno(
    nome: "Pedro Clone 2", email: "carlos@email.com", telefone: "11000000002",
    cpf: "000.000.002-00", endereco: "Rua Z", matricula: "ACM-099",
    plano: planoMensal, nivel: .iniciante, frequenciaSemanal: 1,
    pesoKg: 68.0, alturaMetros: 1.75, objetivoTreino: "Saúde",
    possuiAtestadoMedico: false
)
academia.cadastrarAluno(aluno: alunoEmailRepetido)

print("\n--- Cadastro de Equipamentos ---")
let esteira = Equipamento(nomeItem: "Esteira Speedo TX500",  numeroSerie: "SN-4821",
    anoAquisicao: 2021, estadoAtual: .emFuncionamento, localizacaoNaSala: "Cardio - P1")
let bike = Equipamento(nomeItem: "Bike Spinning Pro 3000",   numeroSerie: "SN-1100",
    anoAquisicao: 2020, estadoAtual: .emFuncionamento, localizacaoNaSala: "Spinning - P4")
let haltere = Equipamento(nomeItem: "Halter 20kg",           numeroSerie: "SN-0033",
    anoAquisicao: 2018, estadoAtual: .defeituoso,       localizacaoNaSala: "Musculação - Rack 2")
let remador = Equipamento(nomeItem: "Remador Concept2",      numeroSerie: "SN-7711",
    anoAquisicao: 2022, estadoAtual: .emFuncionamento,  localizacaoNaSala: "Cardio - P5")

academia.cadastrarEquipamento(equipamento: esteira)
academia.cadastrarEquipamento(equipamento: bike)
academia.cadastrarEquipamento(equipamento: haltere)   
academia.cadastrarEquipamento(equipamento: remador)

academia.executarManutencaoLote(data: "2025-06-10", descricao: "Revisão mensal padrão")

print("\n--- Turmas Coletivas ---")
let turmaYoga = TurmaColetiva(
    nomeAula: "Yoga Matinal", instrutor: fernanda, categoria: .yoga,
    descricao: "Yoga com foco em respiração e postura.",
    horario: "Seg e Qua - 07:00", capacidadeMaxima: 2, capacidadeMinima: 1
)
let turmaMusc = TurmaColetiva(
    nomeAula: "Musculação Avançada", instrutor: rafael, categoria: .musculacao,
    descricao: "Treino de força para alunos avançados.",
    horario: "Ter e Qui - 18:00", capacidadeMaxima: 10, capacidadeMinima: 3
)

academia.cadastrarTurma(turma: turmaYoga)
academia.cadastrarTurma(turma: turmaMusc)

turmaYoga.inscreverAluno(aluno: beatriz)
turmaYoga.inscreverAluno(aluno: ana)

print("\n-- Barreira: turma lotada --")
turmaYoga.inscreverAluno(aluno: carlos)

print("\n-- Barreira: aluno já inscrito --")
turmaYoga.inscreverAluno(aluno: beatriz)

print("\n--- Agendamento de Personal ---")

academia.agendarSessaoPersonal(
    aluno: carlos, instrutor: rafael, categoria: .musculacao,
    data: "2025-06-15", duracaoMinutos: 60, valorSessao: 120.00,
    observacoesSaude: "Sem restrições."
)

academia.agendarSessaoPersonal(
    aluno: ana, instrutor: fernanda, categoria: .yoga,
    data: "2025-06-16", duracaoMinutos: 45, valorSessao: 100.00,
    observacoesSaude: "Iniciante — foco em posturas básicas."
)

print("\n-- Barreira: plano sem personal --")
academia.agendarSessaoPersonal(
    aluno: beatriz, instrutor: rafael, categoria: .musculacao,
    data: "2025-06-17", duracaoMinutos: 60, valorSessao: 120.00,
    observacoesSaude: "Sem restrições."
)

academia.agendarSessaoPersonal(
    aluno: lucas, instrutor: joao, categoria: .luta,
    data: "2025-06-18", duracaoMinutos: 90, valorSessao: 150.00,
    observacoesSaude: "Atleta experiente."
)

//Polimorfismo 1

print("\n--- Polimorfismo: coleção de Pessoas ---")
let todasAsPessoas: [Pessoa] = [carlos, beatriz, lucas, ana, fernanda, rafael, joao]

for pessoa in todasAsPessoas {
    print("  →", pessoa.descricao())
}

//Polimorfismo 2

print("\n--- Polimorfismo: coleção de Aulas ---")

let sessaoCarlos = TreinoPersonal(
    nomeAula: "Personal Funcional — Lucas", instrutor: joao, categoria: .funcional,
    descricao: "Treino funcional de alta intensidade.", aluno: lucas,
    duracaoMinutos: 75, valorSessao: 130.00, observacoesSaude: "Nenhuma restrição."
)

let todasAsAulas: [Aula] = [turmaYoga, turmaMusc, sessaoCarlos]

for aula in todasAsAulas {
    print("  → Aula: \(aula.nomeAula) | Categoria: \(aula.categoria) | Instrutor: \(aula.instrutor.nome)")
}

//Relatório Final de Métricas

academia.exibirRelatorio()
