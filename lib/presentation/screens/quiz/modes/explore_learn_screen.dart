import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../domain/entities/region.dart';

class ExploreLearnScreen extends StatefulWidget {
  const ExploreLearnScreen({super.key});

  @override
  State<ExploreLearnScreen> createState() => _ExploreLearnScreenState();
}

class _ExploreLearnScreenState extends State<ExploreLearnScreen> {
  // Kullanıcının dokunarak bulanıklığını kaldırdığı etiketlerin ID'lerinin tutulduğu liste.
  final Set<String> _revealedRegions = {};

  // Bu liste normalde Supabase'den gelecek.
  // Şimdilik sahte (mock) veri kullanılıyor.
  // Bu liste normalde Supabase'den gelecek.
  // Görseldeki konumlara göre tahmini x ve y yüzdeleri girilmiştir.
  final List<Region> mockRegions = [
    const Region(
      id: "nucleus",
      label: "Çekirdek",
      description: "Hücrenin yönetim ve kalıtım merkezi.",
      svgElementId: "layer_nucleus",
      x: 65.0,
      y: 25.0,
    ),
    const Region(
      id: "mitochondria",
      label: "Mitokondri",
      description: "Hücrenin enerji (ATP) santrali.",
      svgElementId: "layer_mitochondria",
      x: 18.0,
      y: 60.0,
    ),
    const Region(
      id: "golgi",
      label: "Golgi Aygıtı",
      description: "Hücre içi paketleme ve salgı merkezi.",
      svgElementId: "layer_golgi",
      x: 65.0,
      y: 65.0,
    ),
    const Region(
      id: "centriole",
      label: "Sentriyol",
      description: "Hücre bölünmesinde iğ ipliklerini oluşturur.",
      svgElementId: "layer_centriole",
      x: 35.0,
      y: 30.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keşfet ve Öğren')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: Colors.blueGrey.shade50, // Test için arka plan rengi
                child: SvgPicture.asset('assets/diagrams/cell.svg', fit: BoxFit.contain),
              ),
              ...mockRegions.map((region) {
                final double leftPosition = (constraints.maxWidth * (region.x / 100));
                final double topPosition = (constraints.maxHeight * (region.y / 100));

                final isRevealed = _revealedRegions.contains(region.id);

                return Positioned(
                  //Widget'ın tam ortasını referans noktası yapıyorum
                  left: leftPosition - 50,
                  top: topPosition - 20,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _revealedRegions.add(region.id);
                      });
                    },
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: isRevealed ? 0 : 6.0,
                        sigmaY: isRevealed ? 0 : 6.0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              )
                            ]
                        ),
                        child: Text(
                          region.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}