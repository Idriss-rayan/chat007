import 'package:flutter/material.dart';

class ContactCard extends StatefulWidget {
  final Map<String, dynamic> contact;

  const ContactCard({
    super.key,
    required this.contact,
  });

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final contact = widget.contact;
    final bool isMale = contact['gender'] == 'Homme';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFFF6B35).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          splashColor: const Color(0xFFFF6B35).withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar avec dégradé
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isMale
                              ? [
                                  const Color(0xFF4A90E2),
                                  const Color(0xFF67B26F)
                                ]
                              : [
                                  const Color(0xFFFF6B9D),
                                  const Color(0xFFFF6B35)
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: (isMale
                                    ? const Color(0xFF4A90E2)
                                    : const Color(0xFFFF6B9D))
                                .withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          contact['first_name'][0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Informations du contact
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${contact['first_name']} ${contact['last_name']}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${contact['city']}, ${contact['country']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            contact['email'],
                            style: TextStyle(
                              fontSize: 13,
                              color: const Color(0xFFFF6B35),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Badge genre
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isMale
                            ? const Color(0xFF4A90E2).withOpacity(0.1)
                            : const Color(0xFFFF6B9D).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isMale
                              ? const Color(0xFF4A90E2).withOpacity(0.3)
                              : const Color(0xFFFF6B9D).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        contact['gender'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isMale
                              ? const Color(0xFF4A90E2)
                              : const Color(0xFFFF6B9D),
                        ),
                      ),
                    ),
                  ],
                ),

                // Section dépliante
                if (_isExpanded) ...[
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(
                        icon: Icons.phone,
                        label: 'Appeler',
                        color: const Color(0xFF4CAF50),
                        onTap: () {
                          // Action d'appel
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.email,
                        label: 'Email',
                        color: const Color(0xFFFF6B35),
                        onTap: () {
                          // Action email
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.message,
                        label: 'SMS',
                        color: const Color(0xFF2196F3),
                        onTap: () {
                          _startPrivateChat(context);
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(
              icon,
              size: 20,
              color: color,
            ),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _startPrivateChat(BuildContext context) {
    // Pour l'instant, on affiche juste un message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Démarrer chat avec ${widget.contact['first_name']}'),
        backgroundColor: const Color(0xFFFF6B35),
      ),
    );
  }
}
