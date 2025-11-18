import '../data/constants.dart';
import '../models/product_data_model.dart';

final List<Product> mockProducts = [
  Product(
    id: 'p1',
    name: 'Wireless Headphones',
    description: 'High quality noise cancelling headphones',
    category: 'Electronics & Accessories',
    price: 50000.0,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLWzLbJykwJwSFmTW6k1j0ogosFEtObhajbQ&s',
  ),
  Product(
    id: 'p2',
    name: 'Smartphone Case',
    description: 'Durable and stylish phone case',
    category: 'Electronics & Accessories',
    price: 1500.0,
    imageUrl:
        'https://ng.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/00/1587814/1.jpg?2498',
  ),
  Product(
    id: 'p2',
    name: 'ASUS 8th Gen Laptop',
    description:
        'ASUS VivoBook X515JA-EJ301T Laptop, Intel Core i3-1005G1, 8GB RAM, 256GB SSD, 15.6" FHD, Windows 10 Home in S Mode, Silver',
    category: 'Electronics & Accessories',
    price: 150000.0,
    imageUrl:
        'https://ng.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/00/1587814/1.jpg?2498',
  ),
  Product(
    id: 'p3',
    name: 'Graphic T-Shirt',
    description: 'Comfortable cotton shirt with cool design',
    category: 'Fashion & Clothing',
    price: 10000.0,
    imageUrl:
        'https://www.themanual.com/wp-content/uploads/sites/9/2022/02/igwm-graphic-tee.jpeg?resize=1200%2C720&p=1',
  ),
  Product(
    id: 'p4',
    name: 'Denim Jacket',
    description: 'Stylish denim jacket, perfect for campus',
    category: 'Fashion & Clothing',
    price: 6500.0,
    imageUrl:
        'https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcSdBph5Yy85P7eleHZxM8jhwaJPvKOnFT30Mnj5091Sdfzwgbl_bBMUyW2DMgRwlLn6ZVybPrYBBNdbrOaHpZSy6ehPvuxZqZV2Voy5oY82LpHZtKH2RaSwl0Xv50RLjliR1A&usqp=CAc',
  ),
  Product(
    id: 'p5',
    name: 'Calculus Textbook',
    description: 'Comprehensive guide to calculus',
    category: 'Books & Stationery',
    price: 4000.0,
    imageUrl:
        'https://u-mercari-images.mercdn.net/photos/m54874535565_1.jpg?1747435184',
  ),
  Product(
    id: 'p6',
    name: 'Notebook Set',
    description: 'Pack of three notebooks for your classes',
    category: 'Books & Stationery',
    price: 3000.0,
    imageUrl:
        'https://cutethingsfromjapan.com/cdn/shop/products/ZE001-006_9652b757-d82c-4aac-9603-e2ab661cfe3e.jpg?v=1700652420&width=1946',
  ),
  Product(
    id: 'p7',
    name: 'Laundry Basket',
    description: 'Spacious basket for room essentials',
    category: 'Hostel & Room Items',
    price: 2000.0,
    imageUrl:
        'https://ng.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/16/819268/1.jpg?0120',
  ),
  Product(
    id: 'p8',
    name: 'LED Desk Lamp',
    description: 'Adjustable LED lamp for studying',
    category: 'Hostel & Room Items',
    price: 3000.0,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0NffoW4oy30qSWKnNfwS2fM5-ceUOPfibIg&s',
  ),
  Product(
    id: 'p9',
    name: 'Face Care Kit',
    description: 'Complete kit for daily skin care',
    category: 'Beauty & Personal Care',
    price: 4500.0,
    imageUrl:
        'https://ng.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/85/4156814/1.jpg?9472',
  ),
  Product(
    id: 'p10',
    name: 'Hair Styling Set',
    description: 'Set of styling products and tools',
    category: 'Beauty & Personal Care',
    price: 3500.0,
    imageUrl:
        'https://ng.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/12/0779804/1.jpg?0293',
  ),
  Product(
    id: 'p11',
    name: 'Brand Design Service',
    description: 'Logo and branding service by student designers',
    category: 'Services',
    price: 5000.0,
    imageUrl:
        'https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/252132545/original/ad83523465d8270f5b777044dd49be839524f046/create-any-kind-of-graphic-design-with-idea.png',
  ),
  Product(
    id: 'p11',
    name: 'Banner Design ',
    description: 'Design service for banners and posters by student designers',
    category: 'Services',
    price: 10000.0,
    imageUrl:
        'https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/252132545/original/ad83523465d8270f5b777044dd49be839524f046/create-any-kind-of-graphic-design-with-idea.png',
  ),
  Product(
    id: 'p12',
    name: 'Food Delivery',
    description: 'Meal plan and delivery service on campus',
    category: 'Food Delivery',
    price: 2000.0,
    imageUrl:
        'https://scontent.fabb1-3.fna.fbcdn.net/v/t39.30808-6/479715351_600434569426548_2184189048591235289_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeFUVtCRr3p6sUBbSQc2XHu7sa7PuuZlND6xrs-65mU0PvrcHs3_i-ohaXDX4Sa6ZgoNd0yhaUZA8mhSgjAAHb2J&_nc_ohc=iwjQffab0SsQ7kNvwFoNi2k&_nc_oc=AdnB3kgh0tvstu9PWIwzb7N3QaFrG20Uxu8gtPmBha_lYaGsopX1defuYAlGGfH_Vdr_wTZH689yRRVQlkreRlLr&_nc_zt=23&_nc_ht=scontent.fabb1-3.fna&_nc_gid=ETCegS8tqPPVp636f0guFg&oh=00_AfjM6WB22cjLNK1DKtRnXMTZDdhDbWbCd1BgApjy2TgePg&oe=692212D3',
  ),
  Product(
    id: 'p13',
    name: 'Campus Hoodie',
    description: 'Official university hoodie for campus events',
    category: 'Campus Merch',
    price: 8000.0,
    imageUrl:
        'https://ih1.redbubble.net/image.1797387176.5236/ssrco,mhoodie,mens,2445a6:c81b382e98,front,tall_three_quarter,x1000-bg,f8f8f8.1u3.jpg',
  ),
  Product(
    id: 'p14',
    name: 'Anatomy Textbook',
    description: 'Affordable used textbook, good condition',
    category: 'Second-hand / Thrift',
    price: 15000.0,
    imageUrl: 'https://i.ebayimg.com/images/g/55sAAeSwCHJo~O6A/s-l1600.webp',
  ),
  Product(
    id: 'p15',
    name: 'Vintage Jacket',
    description: 'Second-hand vintage jacket in excellent condition',
    category: 'Second-hand / Thrift',
    price: 5000.0,
    imageUrl: 'https://i.ebayimg.com/images/g/T9gAAOSwN9pnWa6M/s-l500.webp',
  ),
];

Map<String, List<Product>> groupProductsByCategory(List<Product> products) {
  Map<String, List<Product>> categorized = {};
  for (var cat in productCategories) {
    categorized[cat] = [];
  }
  for (var product in products) {
    if (categorized.containsKey(product.category)) {
      categorized[product.category]!.add(product);
    } else {
      categorized['Others'] = (categorized['Others'] ?? [])..add(product);
    }
  }
  return categorized;
}
