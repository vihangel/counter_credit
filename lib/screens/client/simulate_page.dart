import 'dart:html' as html;

import 'package:counter_credit/models/calculate_product_model.dart';
import 'package:counter_credit/models/simulate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SimulatePage extends StatefulWidget {
  final Simulate simulate;
  final String payment;
  final String credit;
  final String gracePeriod;

  const SimulatePage({
    super.key,
    required this.simulate,
    required this.payment,
    required this.credit,
    required this.gracePeriod,
  });

  @override
  State<SimulatePage> createState() => _SimulatePageState();
}

class _SimulatePageState extends State<SimulatePage> {
  CalculateProductModel? product;

  String formatCurrency(double value) {
    return 'R\$${value.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+,)'), (Match m) => '${m[1]}.')}';
  }

  @override
  void initState() {
    super.initState();
    product = widget.simulate.gerarParcelas();
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final double? bonus = product!.product?.bonusDia;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/conecta.png', height: 100),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width - 32) > 1000
                      ? 1000
                      : (MediaQuery.of(context).size.width - 32 < 700)
                          ? 700
                          : MediaQuery.of(context).size.width - 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Simulação de Crédito',
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        textAlign: TextAlign.left,
                        'Valor do Crédito: ${formatCurrency(
                          double.parse(widget.credit),
                        )}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        textAlign: TextAlign.left,
                        'Prazo: ${widget.payment} ${widget.payment == '1' ? 'mês' : 'meses'}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        textAlign: TextAlign.left,
                        'Amortização: ${widget.gracePeriod} ${widget.gracePeriod == '1' ? 'mês' : 'meses'}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (bonus != null)
                        Text(
                          textAlign: TextAlign.left,
                          'Bônus de pagamento em dia: $bonus%',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: const Color.fromARGB(255, 8, 160, 86),
                              ),
                        )
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text('#', textAlign: TextAlign.left),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          'Correção',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          'Juros',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          'Amortização',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          'Valor',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          'Bônus Pag. Dia',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromARGB(255, 8, 160, 86),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          'Saldo Devedor',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Column(
                    children: List<Widget>.generate(product!.parcelas.length,
                        (index) {
                      final parcela = product!.parcelas[index];
                      return Container(
                        color: index % 2 == 0
                            ? Colors.grey[100]
                            : Colors.transparent,
                        padding: const EdgeInsets.all(8),
                        child: Flex(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text('${parcela.parcela}',
                                    textAlign: TextAlign.left)),
                            Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Text(
                                    formatCurrency(parcela.correcaoMonetaria),
                                    textAlign: TextAlign.left)),
                            Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Text(formatCurrency(parcela.juros),
                                    textAlign: TextAlign.left)),
                            Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Text(formatCurrency(parcela.amortizacao),
                                    textAlign: TextAlign.left)),
                            Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Text(formatCurrency(parcela.valor),
                                    textAlign: TextAlign.left)),
                            Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: Text(
                                formatCurrency(parcela.comBonus),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 8, 160, 86),
                                ),
                              ),
                            ),
                            Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Text(
                                    formatCurrency(parcela.saldoDevedor),
                                    textAlign: TextAlign.left)),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      const Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text('Total', textAlign: TextAlign.left),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          formatCurrency(product!.correcaoMonetariaTotal),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          formatCurrency(product!.jurosTotal),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          formatCurrency(product!.amortizacaoTotal),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          formatCurrency(product!.valorTotal),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          formatCurrency(product!.bonusTotal),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 8, 160, 86),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          formatCurrency(product!.valorFinanciamento),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      '(*) Os valores das prestações são aproximados. As opções apresentadas não valem como proposta e representam apenas uma simulação com o intuito de subsidiar a tomada de decisão. Até a contratação da operação, a taxa de juros, prazo e demais condições podem ser alteradas sem prévio aviso. As operações de crédito estão sujeitas à análise e aprovação da Desenvolve MT.'),
                  const SizedBox(height: 16),
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 16,
                    children: [
                      ElevatedButton(
                          onPressed: () => GoRouter.of(context).pop(),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              Text(
                                'Fazer nova simulação',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),
                      ElevatedButton(
                          onPressed: createPDF,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.print,
                                color: Colors.white,
                              ),
                              Text(
                                'Imprimir',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final pdf = pw.Document();
  var anchor;

  void createPDF() async {
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(level: 0, child: pw.Text("Simulação de Crédito")),
            pw.TableHelper.fromTextArray(context: context, data: <List<String>>[
              <String>[
                'Parcela',
                'Valor',
                'Amortização',
                'Correção',
                'Juros',
                'Bônus',
                'Saldo Devedor'
              ],
              ...product!.parcelas.map((item) => [
                    item.parcela.toString(),
                    formatCurrency(item.valor),
                    formatCurrency(item.amortizacao),
                    formatCurrency(item.correcaoMonetaria),
                    formatCurrency(item.juros),
                    formatCurrency(item.comBonus),
                    formatCurrency(item.saldoDevedor)
                  ])
            ]),
          ];
        }));
    savePDF();
  }

  void savePDF() async {
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'simulacao_credito.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
