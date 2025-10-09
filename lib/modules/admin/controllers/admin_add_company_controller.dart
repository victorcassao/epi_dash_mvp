// lib/modules/admin/controllers/admin_add_company_controller.dart
import 'package:epi_dash_mvp/modules/admin/models/admin_company_model.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_company_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAddCompanyController extends GetxController {
  final AdminCompanyService companyService;
  final String token;

  AdminAddCompanyController({
    required this.companyService,
    required this.token,
  });

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> createCompany({
    required String name,
    required String cnpj,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final company = AdminCompanyModel(
        name: name,
        cnpj: cnpj,
      );

      await companyService.createCompany(company, token);

      Get.snackbar(
        'Sucesso',
        'Empresa cadastrada com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Aguarda um pouco para o usuário ver a mensagem
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back(); // Volta para tela anterior
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Não foi possível cadastrar empresa: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }
}