import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/model/channel.dart';
import 'package:url_launcher/url_launcher.dart';

String channelLabel(AppLocalizations l, Channel c) => switch (c) {
  Channel.TELEGRAM => 'Telegram',
  Channel.VIBER => 'Viber',
  Channel.WHATSAPP => 'WhatsApp',
  Channel.INSTAGRAM => 'Instagram',
  Channel.FACEBOOK => 'Facebook',
  Channel.TIKTOK => 'TikTok',
  Channel.WEBSITE => l.channel_WEBSITE,
  Channel.PHONE_CALL => l.channel_PHONE_CALL,
  Channel.REFERRAL => l.channel_REFERRAL,
  Channel.OTHER => l.channel_OTHER,
  Channel.unknown => l.channel_OTHER,
};

/// Brand-coloured two-letter marks for messengers (no brand icons in the Material set), generic icons otherwise.
class ChannelIcon extends StatelessWidget {
  const ChannelIcon(this.channel, {this.size = 20, super.key});

  final Channel channel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (String? mark, Color color, IconData? icon) = switch (channel) {
      Channel.TELEGRAM => ('TG', Colors.lightBlue, null),
      Channel.VIBER => ('VB', Colors.deepPurple, null),
      Channel.WHATSAPP => ('WA', Colors.green, null),
      Channel.INSTAGRAM => ('IG', Colors.pink, null),
      Channel.FACEBOOK => ('FB', Colors.blue, null),
      Channel.TIKTOK => ('TT', Colors.black, null),
      Channel.WEBSITE => (null, Colors.blueGrey, Icons.language),
      Channel.PHONE_CALL => (null, Colors.blueGrey, Icons.call),
      Channel.REFERRAL => (null, Colors.blueGrey, Icons.handshake_outlined),
      _ => (null, Colors.blueGrey, Icons.more_horiz),
    };
    return Tooltip(
      message: channelLabel(AppLocalizations.of(context), channel),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: mark != null ? color : color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: mark != null
            ? Text(
                mark,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.42,
                  fontWeight: FontWeight.w800,
                ),
              )
            : Icon(icon, size: size * 0.65, color: color),
      ),
    );
  }
}

/// Icon + label + details (nick / link / group); a link opens in the browser.
class ChannelLine extends StatelessWidget {
  const ChannelLine({required this.channel, this.details, super.key});

  final Channel channel;
  final String? details;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final uri = channelDetailsUri(details);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChannelIcon(channel),
        const SizedBox(width: 6),
        Flexible(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: channelLabel(l, channel)),
                if (details != null && details!.isNotEmpty) ...[
                  const TextSpan(text: ' · '),
                  TextSpan(
                    text: details,
                    style: uri != null
                        ? TextStyle(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          )
                        : TextStyle(color: theme.hintColor),
                  ),
                ],
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (uri != null)
          IconButton(
            icon: const Icon(Icons.open_in_new, size: 16),
            visualDensity: VisualDensity.compact,
            onPressed: () =>
                launchUrl(uri, mode: LaunchMode.externalApplication),
          ),
      ],
    );
  }
}

/// "https://…" and "t.me/…"-style values are links; "@nick" and free text are not.
Uri? channelDetailsUri(String? details) {
  final v = details?.trim() ?? '';
  if (v.isEmpty) return null;
  if (RegExp('^https?://', caseSensitive: false).hasMatch(v)) {
    return Uri.tryParse(v);
  }
  if (RegExp(
    r'^(www\.|t\.me/|instagram\.com/|facebook\.com/|tiktok\.com/|wa\.me/|invite\.viber\.com/)',
    caseSensitive: false,
  ).hasMatch(v)) {
    return Uri.tryParse('https://$v');
  }
  return null;
}

/// Dropdown for forms; `null` = not set.
class ChannelDropdown extends StatelessWidget {
  const ChannelDropdown({
    required this.value,
    required this.onChanged,
    this.hint,
    super.key,
  });

  final Channel? value;
  final ValueChanged<Channel?> onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DropdownButtonFormField<Channel?>(
      // Re-create the field when the value is set from outside (e.g. prefilled from the picked client).
      key: ValueKey(value),
      initialValue: value,
      decoration: InputDecoration(labelText: l.channel_label, helperText: hint),
      items: [
        DropdownMenuItem<Channel?>(child: Text(l.channel_none)),
        for (final c in Channel.values.where((c) => c != Channel.unknown))
          DropdownMenuItem<Channel?>(
            value: c,
            child: Row(
              children: [
                ChannelIcon(c, size: 18),
                const SizedBox(width: 8),
                Text(channelLabel(l, c)),
              ],
            ),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
