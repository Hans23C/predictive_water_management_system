import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../theme/app_theme.dart';

class DemoCredentialsWidget extends StatelessWidget {
  const DemoCredentialsWidget({super.key});

  static const List<Map<String, String>> _demoAccounts = [
    {
      'role': 'Administrador General',
      'email': 'admin@aquacampus.edu.co',
      'password': 'Admin#2024',
      'icon': 'admin_panel_settings',
    },
    {
      'role': 'Personal de Mantenimiento',
      'email': 'mantenimiento@aquacampus.edu.co',
      'password': 'Mant#2024',
      'icon': 'build',
    },
  ];

  void _copyToClipboard(BuildContext context, String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    Fluttertoast.showToast(
      msg: '$label copiado al portapapeles',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.primary,
      textColor: Colors.white,
      fontSize: 13,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.infoContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.info.withAlpha(51), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppTheme.info, size: 16),
              const SizedBox(width: 6),
              Text(
                'Cuentas de demostración',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(_demoAccounts.length, (i) {
            final account = _demoAccounts[i];
            return Padding(
              padding: EdgeInsets.only(
                bottom: i < _demoAccounts.length - 1 ? 12 : 0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(179),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withAlpha(31),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            account['icon'] == 'admin_panel_settings'
                                ? Icons.admin_panel_settings_outlined
                                : Icons.build_outlined,
                            size: 16,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          account['role']!,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _CredentialRow(
                      label: 'Email',
                      value: account['email']!,
                      onCopy: () =>
                          _copyToClipboard(context, account['email']!, 'Email'),
                    ),
                    const SizedBox(height: 4),
                    _CredentialRow(
                      label: 'Contraseña',
                      value: account['password']!,
                      onCopy: () => _copyToClipboard(
                        context,
                        account['password']!,
                        'Contraseña',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _CredentialRow({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A2B2C),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onCopy,
          child: Icon(Icons.copy_rounded, size: 14, color: AppTheme.primary),
        ),
      ],
    );
  }
}
