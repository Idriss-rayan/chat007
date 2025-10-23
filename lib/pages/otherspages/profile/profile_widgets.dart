// profile_widgets.dart
import 'package:flutter/material.dart';
import 'profile_colors.dart';

class ProfileWidgets {
  static Widget buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: isDestructive
            ? LinearGradient(
                colors: [Colors.red.shade50, Colors.red.shade50],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : LinearGradient(
                colors: [
                  ProfileColors.white,
                  ProfileColors.lightPink.withOpacity(0.05)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDestructive
              ? Colors.red.withOpacity(0.2)
              : ProfileColors.lightPink.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: ListTile(
        leading: Icon(icon,
            color: isDestructive ? Colors.red : ProfileColors.primaryOrange,
            size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: isDestructive ? Colors.red.shade400 : Colors.grey.shade600,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive
              ? Colors.red
              : ProfileColors.primaryOrange.withOpacity(0.7),
          size: 20,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  static Widget buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: ProfileColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ProfileColors.lightOrange.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: ProfileColors.buttonGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: ProfileColors.white),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ProfileColors.primaryOrange,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildSection(
      {required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ProfileColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ProfileColors.lightPink.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: ProfileColors.lightPink.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ProfileColors.primaryOrange,
              ),
            ),
          ),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  static Widget buildEditOption(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ProfileColors.white,
            ProfileColors.lightPink.withOpacity(0.1)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ProfileColors.lightPink.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: ProfileColors.primaryOrange, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              )
            : null,
        trailing: Icon(Icons.chevron_right,
            color: ProfileColors.primaryOrange.withOpacity(0.7)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        onTap: onTap,
      ),
    );
  }

  static Widget buildPhotoOption(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: color == Colors.red ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  static Widget buildBackupOption(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ProfileColors.lightPink.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: ProfileColors.primaryOrange, size: 22),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        onTap: onTap,
      ),
    );
  }

  static Widget buildLanguageOption(
      String language, bool isSelected, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  ProfileColors.lightOrange.withOpacity(0.1),
                  ProfileColors.pink.withOpacity(0.1)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? ProfileColors.primaryOrange.withOpacity(0.3)
              : Colors.transparent,
          width: 0.5,
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.language,
            color: isSelected ? ProfileColors.primaryOrange : Colors.grey),
        title: Text(language),
        trailing: isSelected
            ? Icon(Icons.check, color: ProfileColors.primaryOrange)
            : null,
        onTap: onTap,
      ),
    );
  }
}
