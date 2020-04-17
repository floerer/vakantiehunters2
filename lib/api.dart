import 'package:woocommerce_api/woocommerce_api.dart';

List<String> categoryList = new List<String>();
List<Holiday> holidayList = new List<Holiday>();


class ApiData{
  WooCommerceAPI wc;
  bool getHolidaysRun;
  bool getCategoriesRun;
  var categories;
  var holidays;

  ApiData({this.wc, this.getCategoriesRun, this.getHolidaysRun }){
    this.wc = new WooCommerceAPI('https://vakantiehunters.nl', 'ck_91a67864eb2d77b1cc9147d57fc50bedf4b8a0c3', 'cs_6fff24be015a7b73aaf455db9de3bf3474345080');
    this.getCategoriesRun = false;
    this.getHolidaysRun = false;
  }

  //Retrieve the woocommerce product categories from the vakantiehunters API
  getCategories() async{
    /// Get data using the endpoint
    if(!getCategoriesRun){
      categories = await wc.getAsync("products/categories?&orderby=count&hide_empty=true&per_page=60&order=desc");
      getCategoriesRun = true;
      return categories;
    } else {
      return categories;
    }
  }

  //Retrieve the woocommerce products from the vakantiehunter API
  getHolidays() async {
    // Get data using the endpoint
    if(!getHolidaysRun){
      holidays = await wc.getAsync("products?per_page=45");
      getHolidaysRun = true;
      return holidays;
    } else {
      return holidays;
    }
  }

  //Retrieve specific categorie/location holidays from the API
  getCategoryHolidays(int categorie) async{
    var p = await wc.getAsync("products?category=" + categorie.toString());
    return p;
  }

  getHoliday(int id) async{
    var p = await wc.getAsync("products/" + id.toString());
    return p;
  }
}

class Holiday{
  String title;
  String description;
  String newPrice;
  String oldPrice;
  List<String> categories;
  List<String> tags;
  String url;

  Holiday(String t, String d, String o, String n, String u, List<String> c, List<String> tags){
    this.title = t;
    this.description = d;
    this.oldPrice = o;
    this.newPrice = n;
    this.categories = c;
    this.tags = tags;
    this.url = u;
  }
}
