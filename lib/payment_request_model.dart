class PaymentRequestModel {
  String? mode;
  List<String>? paymentMethodTypes;
  List<LineItems>? lineItems;
  String? successUrl;
  String? cancelUrl;

  PaymentRequestModel(
      {this.mode,
      this.paymentMethodTypes,
      this.lineItems,
      this.successUrl,
      this.cancelUrl});

  PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    mode = json['mode'];
    paymentMethodTypes = json['payment_method_types'].cast<String>();
    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(new LineItems.fromJson(v));
      });
    }
    successUrl = json['success_url'];
    cancelUrl = json['cancel_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mode'] = this.mode;
    data['payment_method_types'] = this.paymentMethodTypes;
    if (this.lineItems != null) {
      data['line_items'] = this.lineItems!.map((v) => v.toJson()).toList();
    }
    data['success_url'] = this.successUrl;
    data['cancel_url'] = this.cancelUrl;
    return data;
  }
}

class LineItems {
  PriceData? priceData;
  int? quantity;

  LineItems({this.priceData, this.quantity});

  LineItems.fromJson(Map<String, dynamic> json) {
    priceData = json['price_data'] != null
        ? new PriceData.fromJson(json['price_data'])
        : null;
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priceData != null) {
      data['price_data'] = this.priceData!.toJson();
    }
    data['quantity'] = this.quantity;
    return data;
  }
}

class PriceData {
  String? currency;
  ProductData? productData;
  int? unitAmount;

  PriceData({this.currency, this.productData, this.unitAmount});

  PriceData.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    productData = json['product_data'] != null
        ? new ProductData.fromJson(json['product_data'])
        : null;
    unitAmount = json['unit_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.currency;
    if (this.productData != null) {
      data['product_data'] = this.productData!.toJson();
    }
    data['unit_amount'] = this.unitAmount;
    return data;
  }
}

class ProductData {
  String? name;

  ProductData({this.name});

  ProductData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
