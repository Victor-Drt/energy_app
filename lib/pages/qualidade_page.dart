import 'package:flutter/material.dart';
import 'package:energy_app/widgets/itens/Qualidadecard.dart';
import 'package:energy_app/services/qualidade_service.dart';
import 'package:energy_app/models/qualidade.dart';
import 'package:intl/intl.dart';

class QualidadePage extends StatefulWidget {
  @override
  _QualidadePageState createState() => _QualidadePageState();
}

class _QualidadePageState extends State<QualidadePage> {
  final QualidadeService _qualidadeService = QualidadeService();
  Qualidade? _qualidade; // Dados da última análise
  Qualidade? _ultimaQualidade; // Dados da última análise salva
  bool _isLoading = false;

  // Função para carregar a última análise do banco ou armazenamento local
  Future<void> _carregarUltimaAnalise() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Busca a lista de análises do serviço
      List<Qualidade>? historico =
          await _qualidadeService.listarHistoricoAnalises();

      if (historico != null && historico.isNotEmpty) {
        // Ordena a lista de análises pela data mais recente primeiro
        historico.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

        // A análise mais recente estará na primeira posição da lista
        _ultimaQualidade = historico.first;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Erro ao carregar a última análise: $e");
    }
  }

  // Função que chama o serviço para gerar uma nova análise
  Future<void> _gerarNovaAnalise() async {
    setState(() {
      _isLoading = true;
    });

    // Definindo as datas de início e fim (últimos 7 dias como exemplo)
    DateTime now = DateTime.now();
    DateTime startDate =
        DateTime(now.year, now.month, now.day - 7); // 7 dias atrás
    DateTime endDate = DateTime(now.year, now.month, now.day);

    try {
      // Chama o serviço para gerar análise de qualidade
      Qualidade? novaQualidade = await _qualidadeService.gerarAnaliseQualidade(
        startDate: startDate,
        endDate: endDate,
      );

      setState(() {
        _qualidade = novaQualidade; // Atualiza o estado com os novos dados
        _isLoading = false; // Finaliza o carregamento
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Erro ao gerar análise: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // Carregar a última análise ao iniciar a tela
    _carregarUltimaAnalise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Análise de Qualidade de Energia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botão para gerar uma nova análise
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _gerarNovaAnalise, // Desabilita o botão se já estiver carregando
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Gerar Nova Análise'),
            ),
            SizedBox(height: 16),
            // Se há uma última análise, exibe ela, senão exibe uma mensagem
            if (_ultimaQualidade != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Última Análise:',
                      style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0, // Espaço horizontal entre os cards
                    runSpacing: 8.0, // Espaço vertical entre os cards
                    children: [
                      // Exibição da última análise
                      SizedBox(
                        width: double.infinity, // Ocupar a largura total
                        child: Qualidadecard(
                          title: 'Fator de Potência',
                          value: _ultimaQualidade?.fatorPotencia
                                  ?.toStringAsFixed(2) ??
                              'N/A',
                        ),
                      ),
                      Qualidadecard(
                        title: 'Flutuuação Tensão Mínima',
                        value: _ultimaQualidade?.flutuacaoTensaoMinima
                                ?.toStringAsFixed(2) ??
                            'N/A',
                      ),
                      Qualidadecard(
                        title: 'Flutuuação Tensão Máxima',
                        value: _ultimaQualidade?.flutuacaoTensaoMaxima
                                ?.toStringAsFixed(2) ??
                            'N/A',
                      ),
                      Qualidadecard(
                        title: 'THD Tensão',
                        value:
                            _ultimaQualidade?.thdTensao?.toStringAsFixed(2) ??
                                'N/A',
                      ),
                      Qualidadecard(
                        title: 'THD Corrente',
                        value:
                            _ultimaQualidade?.thdCorrente?.toStringAsFixed(2) ??
                                'N/A',
                      ),
                      Qualidadecard(
                        title: 'Oscilação Tensão',
                        value: _ultimaQualidade?.oscilacaoTensao
                                ?.toStringAsFixed(2) ??
                            'N/A',
                      ),
                      // Card de Consumo Total (ainda está fixo, pode ser ajustado se tiver dado real)
                      SizedBox(
                        width: double.infinity, // Ocupar a largura total
                        child: Qualidadecard(
                          title: 'Consumo Total Acumulado',
                          value:
                              '1500 kWh', // Pode ser ajustado se houver dado real
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            // Se os dados estão sendo carregados ou não há dados anteriores
            if (_isLoading) Center(child: CircularProgressIndicator()),
            if (_qualidade != null && _ultimaQualidade == null)
              Text('Nenhuma análise anterior foi encontrada.',
                  style: TextStyle(fontSize: 16)),
            // Exibe a nova análise gerada
            if (_qualidade != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nova Análise:',
                      style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0, // Espaço horizontal entre os cards
                    runSpacing: 8.0, // Espaço vertical entre os cards
                    children: [
                      SizedBox(
                        width: double.infinity, // Ocupar a largura total
                        child: Qualidadecard(
                          title: 'Fator de Potência',
                          value:
                              _qualidade?.fatorPotencia?.toStringAsFixed(2) ??
                                  'N/A',
                        ),
                      ),
                      Qualidadecard(
                        title: 'Flutuuação Tensão Mínima',
                        value: _qualidade?.flutuacaoTensaoMinima
                                ?.toStringAsFixed(2) ??
                            'N/A',
                      ),
                      Qualidadecard(
                        title: 'Flutuuação Tensão Máxima',
                        value: _qualidade?.flutuacaoTensaoMaxima
                                ?.toStringAsFixed(2) ??
                            'N/A',
                      ),
                      Qualidadecard(
                        title: 'THD Tensão',
                        value:
                            _qualidade?.thdTensao?.toStringAsFixed(2) ?? 'N/A',
                      ),
                      Qualidadecard(
                        title: 'THD Corrente',
                        value: _qualidade?.thdCorrente?.toStringAsFixed(2) ??
                            'N/A',
                      ),
                      Qualidadecard(
                        title: 'Oscilação Tensão',
                        value:
                            _qualidade?.oscilacaoTensao?.toStringAsFixed(2) ??
                                'N/A',
                      ),
                      // Card de Consumo Total
                      // SizedBox(
                      //   width: double.infinity, // Ocupar a largura total
                      //   child: Qualidadecard(
                      //     title: 'Consumo Total Acumulado',
                      //     value:
                      //         '1500 kWh', // Pode ser ajustado se houver dado real
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
