import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
    console.log('Membersihkan data lama...')
    await prisma.attendance.deleteMany()
    await prisma.communityPost.deleteMany()
    await prisma.user.deleteMany()
    await prisma.event.deleteMany()
    await prisma.familyAltar.deleteMany()
    await prisma.warta.deleteMany()

    console.log('Mulai menyuntikkan data (seeding)...')

    // 1. Buat Data User Dummy
    const user1 = await prisma.user.create({
        data: {
            name: 'Budi Santoso',
            email: 'budi@example.com',
            password: 'hashed_password_here',
            dob: new Date('1990-01-01'),
            gender: 'L',
            phone: '081234567890',
        },
    })

    const user2 = await prisma.user.create({
        data: {
            name: 'Suisei Hoshimachi',
            email: 'suisei@example.com',
            password: 'hashed_password_here',
            dob: new Date('2000-03-22'),
            gender: 'P',
        },
    })

    // 2. Buat Data Warta Jemaat
    await prisma.warta.create({
        data: {
            judul: 'Warta Jemaat Minggu Ke-5 Mei',
            tanggal: new Date('2026-05-31T00:00:00Z'),
            khotbahJudul: 'Hidup dalam Pengharapan',
            khotbahAyat: 'Roma 15:13',
            khotbahIsi: 'Pengharapan di dalam Tuhan tidak pernah mengecewakan. \nMari kita terus berpegang pada janji-Nya di tengah tantangan dunia.',
            jadwalPelayanan: 'Pemusik: Tim A\nPemandu Pujian: Kak Andi\nPenyambut Jemaat: Pemuda',
            infoPenting: '1. Persekutuan Doa: Rabu, pkl 19.00 WIB\n2. Latihan Paduan Suara: Jumat, pkl 18.30 WIB\n3. Rapat Pengurus: Sabtu, pkl 10.00 WIB',
        },
    })

    // 3. Buat Data Event (Smart QR)
    const ibadahRaya = await prisma.event.create({
        data: {
            title: 'Ibadah Raya Minggu',
            date: new Date('2026-05-31T08:00:00Z'),
            description: 'Ibadah umum hari Minggu sesi pertama.',
        },
    })

    // 4. Buat Data Kehadiran (Attendance) 
    await prisma.attendance.create({
        data: {
            userId: user1.id,
            eventId: ibadahRaya.id,
        },
    })

    // 5. Buat Data Papan Interaksi (Doa & Kesaksian)
    await prisma.communityPost.create({
        data: {
            content: 'Tolong doakan ujian akhir semester (UAS) saya minggu depan agar dilancarkan.',
            type: 'PRAYER',
            userId: user1.id,
        },
    })

    await prisma.communityPost.create({
        data: {
            content: 'Puji Tuhan, proyek aplikasi saya akhirnya berjalan lancar berkat kerja sama tim!',
            type: 'TESTIMONY',
            userId: user2.id,
        },
    })

    console.log('Seeding selesai dengan sukses!')
}

main()
    .catch((e) => {
        console.error(e)
        process.exit(1)
    })
    .finally(async () => {
        await prisma.$disconnect()
    })