// lib/data/tramites_data.dart

import '../models/tramite.dart';
import 'package:flutter/material.dart';

const List<Tramite> tramitesData = [
  // ───────── SEGIP ─────────
  Tramite(
    id: 'segip_01',
    nombre: 'Obtención de Cédula de Identidad',
    entidad: 'SEGIP',
    categoria: 'Documentos de Identidad',
    descripcion: 'Trámite para obtener o renovar la cédula de identidad boliviana en La Paz.',
    requisitos: [
      'Certificado de nacimiento original (no mayor a 6 meses)',
      'Fotografía tamaño carnet (fondo blanco)',
      'Pago de arancel en el banco autorizado',
      'Para menores: presencia del padre o tutor con su CI',
    ],
    costo: 'Bs. 40 (primera vez) / Bs. 80 (renovación)',
    pasos: [
      'Obtener certificado de nacimiento en el SERECI',
      'Pagar el arancel en cualquier banco autorizado',
      'Sacar turno en la oficina SEGIP de su zona',
      'Presentarse con todos los documentos en la fecha asignada',
      'Toma de fotografía y datos biométricos',
      'Recoger la cédula en 5 días hábiles',
    ],
    duracionEstimada: '5-7 días hábiles',
    iconoEntidad: '🪪',
    colorEntidad: 0xFF1565C0,
  ),
  Tramite(
    id: 'segip_02',
    nombre: 'Certificado de Nacimiento',
    entidad: 'SEGIP',
    categoria: 'Documentos de Identidad',
    descripcion: 'Obtención del certificado de nacimiento oficial emitido por el SERECI.',
    requisitos: [
      'Número de folio del libro de registros (si se conoce)',
      'Nombres completos del titular',
      'Fecha y lugar de nacimiento aproximada',
      'CI del solicitante (si es mayor de edad)',
    ],
    costo: 'Bs. 20',
    pasos: [
      'Presentarse en la oficina del SERECI de su municipio',
      'Llenar el formulario de solicitud',
      'Pagar el arancel correspondiente',
      'Esperar el tiempo de procesamiento',
      'Recoger el documento',
    ],
    duracionEstimada: '1-3 días hábiles',
    iconoEntidad: '📋',
    colorEntidad: 0xFF1565C0,
  ),

  // ───────── ALCALDÍA ─────────
  Tramite(
    id: 'alc_01',
    nombre: 'Licencia de Funcionamiento',
    entidad: 'Alcaldía',
    categoria: 'Negocios y Comercio',
    descripcion: 'Autorización municipal para operar un negocio o establecimiento comercial en La Paz.',
    requisitos: [
      'Formulario de solicitud de licencia de funcionamiento',
      'Fotocopia de Cédula de Identidad del propietario',
      'NIT del negocio (Número de Identificación Tributaria)',
      'Contrato de alquiler o título de propiedad del local',
      'Plano del local (con medidas)',
      'Pago de patente municipal',
      'Certificado de uso de suelo (según la zona)',
    ],
    costo: 'Bs. 150 - Bs. 500 (según tamaño del negocio)',
    pasos: [
      'Obtener el formulario en la Alcaldía o descargarlo en línea',
      'Llenar el formulario con todos los datos del negocio',
      'Presentar todos los documentos en la ventanilla de Hacienda Municipal',
      'Pagar la patente comercial en caja',
      'Inspección del local por parte del funcionario municipal',
      'Recibir la licencia de funcionamiento aprobada',
    ],
    duracionEstimada: '10-15 días hábiles',
    iconoEntidad: '🏪',
    colorEntidad: 0xFF2E7D32,
  ),
  Tramite(
    id: 'alc_02',
    nombre: 'Certificado de Uso de Suelo',
    entidad: 'Alcaldía',
    categoria: 'Construcción y Urbanismo',
    descripcion: 'Documento que certifica el uso permitido de un terreno o inmueble según el plan urbano.',
    requisitos: [
      'Formulario de solicitud',
      'Título de propiedad del inmueble',
      'Fotocopia de CI del propietario',
      'Plano de ubicación del inmueble',
      'Pago de arancel municipal',
    ],
    costo: 'Bs. 80 - Bs. 200',
    pasos: [
      'Solicitar el formulario en la Dirección de Ordenamiento Territorial',
      'Adjuntar todos los documentos requeridos',
      'Pagar el arancel en caja',
      'Esperar la verificación técnica',
      'Recoger el certificado en la ventanilla',
    ],
    duracionEstimada: '7-10 días hábiles',
    iconoEntidad: '🗺️',
    colorEntidad: 0xFF2E7D32,
  ),
  Tramite(
    id: 'alc_03',
    nombre: 'Permiso de Construcción',
    entidad: 'Alcaldía',
    categoria: 'Construcción y Urbanismo',
    descripcion: 'Autorización para construir, ampliar o modificar una edificación en el municipio de La Paz.',
    requisitos: [
      'Planos arquitectónicos firmados por arquitecto habilitado',
      'Memoria descriptiva del proyecto',
      'Título de propiedad del terreno',
      'Certificado de uso de suelo',
      'CI del propietario',
      'Formulario de solicitud de permiso',
      'Pago de derechos de construcción',
    ],
    costo: 'Variable según m² de construcción (desde Bs. 200)',
    pasos: [
      'Contratar un arquitecto habilitado para los planos',
      'Obtener el certificado de uso de suelo',
      'Presentar expediente completo en la Dirección de Obras Públicas',
      'Revisión técnica de los planos',
      'Pago de derechos de construcción',
      'Recibir el permiso aprobado',
      'Colocar el cartel de obra en el inmueble',
    ],
    duracionEstimada: '15-30 días hábiles',
    iconoEntidad: '🏗️',
    colorEntidad: 0xFF2E7D32,
  ),

  // ───────── BANCOS ─────────
  Tramite(
    id: 'banco_01',
    nombre: 'Apertura de Cuenta de Ahorros',
    entidad: 'Bancos',
    categoria: 'Servicios Bancarios',
    descripcion: 'Proceso para abrir una cuenta de ahorros en cualquier entidad bancaria de Bolivia.',
    requisitos: [
      'Cédula de Identidad vigente',
      'Número de Identificación Tributaria (NIT) - para personas naturales con actividad económica',
      'Depósito inicial mínimo (varía por banco)',
      'Formulario KYC (Conozca a su Cliente) llenado',
      'Para menores: CI del tutor legal',
    ],
    costo: 'Sin costo de apertura (depósito mínimo desde Bs. 50)',
    pasos: [
      'Acudir a la sucursal bancaria de su preferencia con documentos',
      'Solicitar la apertura de cuenta al asesor de servicios',
      'Llenar el formulario KYC con datos personales',
      'Realizar el depósito inicial mínimo',
      'Recibir tarjeta de débito y código de acceso en línea',
      'Activar la cuenta en el cajero automático o app del banco',
    ],
    duracionEstimada: '1 día (mismo día)',
    iconoEntidad: '🏦',
    colorEntidad: 0xFF6A1B9A,
  ),
  Tramite(
    id: 'banco_02',
    nombre: 'Certificación Bancaria',
    entidad: 'Bancos',
    categoria: 'Servicios Bancarios',
    descripcion: 'Documento oficial que certifica la existencia y estado de una cuenta bancaria.',
    requisitos: [
      'Cédula de Identidad del titular',
      'Número de cuenta bancaria',
      'Solicitud firmada por el titular',
      'Pago de arancel bancario',
    ],
    costo: 'Bs. 30 - Bs. 80 (según el banco)',
    pasos: [
      'Presentarse en ventanilla con su CI',
      'Solicitar la certificación bancaria',
      'Pagar el arancel correspondiente',
      'Recoger el documento (mismo día o al día siguiente)',
    ],
    duracionEstimada: '1-2 días hábiles',
    iconoEntidad: '📄',
    colorEntidad: 0xFF6A1B9A,
  ),

  // ───────── IMPUESTOS NACIONALES ─────────
  Tramite(
    id: 'sii_01',
    nombre: 'Obtención de NIT',
    entidad: 'Impuestos Nacionales',
    categoria: 'Tributario',
    descripcion: 'Registro en el Servicio de Impuestos Nacionales para obtener el Número de Identificación Tributaria.',
    requisitos: [
      'Cédula de Identidad vigente',
      'Factura de servicio básico (luz, agua o gas) del domicilio fiscal',
      'Formulario 4016 (disponible en oficinas SIN o en línea)',
      'Para empresas: documentos de constitución legal',
    ],
    costo: 'Gratuito',
    pasos: [
      'Descargar y llenar el formulario 4016 en oficina.impuestos.gob.bo',
      'Reunir todos los documentos requeridos',
      'Presentarse en la oficina del SIN de su distrito',
      'Entregar documentos al funcionario',
      'Recibir el NIT de forma inmediata o en pocos días',
    ],
    duracionEstimada: '1-3 días hábiles',
    iconoEntidad: '🧾',
    colorEntidad: 0xFFC62828,
  ),
  Tramite(
    id: 'sii_02',
    nombre: 'Declaración Jurada de IVA',
    entidad: 'Impuestos Nacionales',
    categoria: 'Tributario',
    descripcion: 'Presentación mensual de la declaración jurada del Impuesto al Valor Agregado.',
    requisitos: [
      'NIT activo',
      'Libros de compras y ventas del mes',
      'Acceso al sistema SIAT (Sistema de Administración Tributaria)',
      'Formularios 200 y 210',
    ],
    costo: 'Gratuito (multas si se presenta fuera de plazo)',
    pasos: [
      'Ingresar al sistema SIAT con su NIT y contraseña',
      'Seleccionar el formulario correspondiente (IVA - Form. 200)',
      'Ingresar los datos de compras y ventas del período',
      'Verificar el monto a pagar o a favor',
      'Presentar la declaración y generar la boleta de pago si corresponde',
      'Pagar en el banco autorizado si hay impuesto a pagar',
    ],
    duracionEstimada: 'Mismo día (trámite en línea)',
    iconoEntidad: '💰',
    colorEntidad: 0xFFC62828,
  ),

  // ───────── TRÁNSITO ─────────
  Tramite(
    id: 'transito_01',
    nombre: 'Licencia de Conducir',
    entidad: 'Tránsito',
    categoria: 'Vehículos y Transporte',
    descripcion: 'Obtención de la licencia de conducir para vehículos motorizados en Bolivia.',
    requisitos: [
      'Cédula de Identidad vigente',
      'Certificado médico de aptitud (COSSMIL, clínica autorizada)',
      'Aprobar el examen teórico de tránsito',
      'Aprobar el examen práctico de manejo',
      'Pago de arancel de licencia',
      'Fotografía tamaño carnet (fondo blanco)',
    ],
    costo: 'Bs. 200 - Bs. 400 (según categoría)',
    pasos: [
      'Obtener el certificado médico en una clínica autorizada',
      'Inscribirse para el examen teórico en la oficina de Tránsito',
      'Estudiar el manual de tránsito y dar el examen teórico',
      'Si aprueba, programar el examen práctico',
      'Dar el examen práctico de manejo',
      'Si aprueba, pagar el arancel y entregar documentos',
      'Recoger la licencia en la fecha indicada',
    ],
    duracionEstimada: '7-15 días hábiles',
    iconoEntidad: '🚗',
    colorEntidad: 0xFFE65100,
  ),
  Tramite(
    id: 'transito_02',
    nombre: 'Registro de Vehículo',
    entidad: 'Tránsito',
    categoria: 'Vehículos y Transporte',
    descripcion: 'Inscripción de un vehículo nuevo o transferencia de propiedad en el Registro de Tránsito.',
    requisitos: [
      'Factura de compra del vehículo (original)',
      'Declaración Única de Importación (DUI) si es importado',
      'CI del propietario',
      'Formulario de solicitud de registro',
      'Pago de impuestos y aranceles',
      'Inspección técnica del vehículo',
    ],
    costo: 'Variable (según año y valor del vehículo)',
    pasos: [
      'Realizar la inspección técnica del vehículo',
      'Presentar documentos en la oficina de Tránsito',
      'Pago de impuestos de registro',
      'Esperar la verificación de documentos',
      'Recibir placa de registro y documentos del vehículo',
    ],
    duracionEstimada: '5-10 días hábiles',
    iconoEntidad: '🚙',
    colorEntidad: 0xFFE65100,
  ),
];

// Lista de entidades únicas
List<String> get entidades {
  return tramitesData.map((t) => t.entidad).toSet().toList()..sort();
}

// Lista de categorías únicas
List<String> get categorias {
  return tramitesData.map((t) => t.categoria).toSet().toList()..sort();
}

// Color por entidad
Color colorPorEntidad(String entidad) {
  final t = tramitesData.firstWhere(
    (t) => t.entidad == entidad,
    orElse: () => tramitesData.first,
  );
  return Color(t.colorEntidad);
}

// Ícono por entidad
String iconoPorEntidad(String entidad) {
  switch (entidad) {
    case 'SEGIP':
      return '🪪';
    case 'Alcaldía':
      return '🏛️';
    case 'Bancos':
      return '🏦';
    case 'Impuestos Nacionales':
      return '🧾';
    case 'Tránsito':
      return '🚦';
    default:
      return '📋';
  }
}
