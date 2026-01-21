// class SyncScreen extends StatefulWidget {
//   const SyncScreen({super.key});

//   @override
//   State<SyncScreen> createState() => _SyncScreenState();
// }

// class _SyncScreenState extends State<SyncScreen> {
//   final _drive = DriveBackupService();
//   final _auth = AuthService();
//   bool _isSyncing = false;
//   int _restoredCount = 0;

//   Future<void> _syncFromDrive() async {
//     setState(() => _isSyncing = true);

//     try {
//       if (!await _auth.isLoggedIn()) {
//         await _auth.signIn();
//       }

//       final restored = await _drive.downloadAndRestoreNotes();
//       setState(() {
//         _restoredCount = restored.length;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Restored $_restoredCount notes from Drive')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Sync failed: $e')),
//       );
//     } finally {
//       setState(() => _isSyncing = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sync with Google Drive')),
//       body: Center(
//         child: _isSyncing
//             ? const Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Syncing notes and images...'),
//                 ],
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Last sync: ...'), // you can add timestamp
//                   const SizedBox(height: 32),
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.cloud_download),
//                     label: const Text('Download from Drive'),
//                     onPressed: _syncFromDrive,
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }