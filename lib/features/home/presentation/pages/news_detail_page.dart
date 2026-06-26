import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  // Menangkap data artikel dinamis yang dikirim saat kartu diklik
  final dynamic article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar Cantik yang bisa mengecil saat di-scroll ke bawah
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.indigo[900],
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: article.urlToImage != null && article.urlToImage.isNotEmpty
                  ? Image.network(
                      article.urlToImage,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_rounded, size: 64, color: Colors.grey),
                    ),
            ),
          ),
          
          // Konten Utama Artikel Berita
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 1. Judul Utama
                Text(
                  article.title ?? 'Tidak ada judul',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                
                // 2. Metadata (Tanggal & Label)
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 16, color: Colors.indigo[400]),
                    const SizedBox(width: 6),
                    Text(
                      article.publishedAt ?? '-',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Berita Utama',
                        style: TextStyle(color: Colors.indigo[900], fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                
                // 3. Isi Konten Artikel Lengkap
                Text(
                  article.content != null && article.content.isNotEmpty 
                      ? article.content 
                      : 'Tidak ada detail konten tambahan untuk artikel ini.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[800],
                    height: 1.7,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          )
        ],
      ),
    );
  }
}