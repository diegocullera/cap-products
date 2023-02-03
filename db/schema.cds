namespace com.dmr2935;

using {
    cuid,
    managed
} from '@sap/cds/common.cds';

define type Name : String(50);

define type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};

context materials {

    entity Products : cuid, managed {
        //key ID               : UUID;
        Name             : localized String not null;
        Description      : localized String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now;
        DiscontinuedDate : DateTime;
        Price            : Decimal(16, 2);
        Height           : type of Price;
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        Supplier         : Association to sales.Suppliers;
        UnitOfMeasure    : Association to UnitOfMeasures;
        Currency         : Association to Currencies;
        DimensionUnit    : Association to DimensionUnits;
        Category         : Association to Categories;
        SalesData        : Association to many sales.SalesData
                               on SalesData.Product = $self;
        Reviews          : Association to many ProductReview
                               on Reviews.Product = $self;
    };

    entity Categories {
        key ID   : String(1);
            Name : localized String;
    };

    entity StockAvailability {
        key ID          : Integer;
            Description : localized String;
            Product     : Association to Products;
    };

    entity Currencies {
        key ID          : String(3);
            Description : localized String;
    };

    entity UnitOfMeasures {
        key ID          : String(2);
            Description : localized String;
    };

    entity DimensionUnits {
        key ID          : String(2);
            Description : localized String;
    };

    entity ProductReview : cuid, managed {
        // key ID      : UUID;
        Name    : String;
        Rating  : Integer;
        Comment : String;
        Product : Association to Products;
    };

    entity SelProducts   as select from Products;
    entity ProjProducts  as projection on Products;

    entity ProjProducts2 as projection on Products {
        *
    };

    entity ProjProducts3 as projection on Products {
        ReleaseDate,
        Name,
    };

    extend Products with {
        PriceCondition     : String(2);
        PriceDetermination : String(3);
    };

}

context sales {

    // Composition ejemplo
    entity Orders : cuid {
        //key ID       : UUID;
        Date     : Date;
        Customer : String;
        Item     : Composition of many OrderItems
                       on Item.Order = $self;
    //Sería válido también lo siguiente:
    // Item     : Composition of many {
    //                key Position : Integer;
    //                    Order    : Association to Orders;
    //                    Product  : Association to Products;
    //                    Quantity : Integer;
    //            }
    };

    entity OrderItems : cuid {
        //key ID       : UUID;
        Order    : Association to Orders;
        Product  : Association to materials.Products;
        Quantity : Integer;
    };

    entity Suppliers : cuid, managed {
        //key ID      : UUID;
        Name    : type of materials.Products : Name;
        Address : Address;
        Email   : String;
        Phone   : String;
        Fax     : String;
        Product : Association to many materials.Products
                      on Product.Supplier = $self;
    };


    entity Months {
        key ID               : String(2);
            Description      : String;
            ShortDescription : localized String(3);
    };

    entity SelProducts1 as
        select from materials.Products {
            *
        };

    entity SelProducts2 as
        select from materials.Products {
            Name,
            Price,
            Quantity,
        };

    entity SelProducts3 as
        select from materials.Products
        left join materials.ProductReview
            on Products.Name = ProductReview.Name
        {
            Rating,
            Products.Name,
            sum(Price) as TotalPrice,
        }
        group by
            Rating,
            Products.Name
        order by
            Rating;


    entity SalesData : cuid, managed {
        //key ID            : UUID;
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        Product       : Association to materials.Products;
        Currency      : Association to materials.Currencies;
        DeliveryMonth : Association to Months;
    };
}


define context reports {

    entity AverageRating as
        select from dmr2935.materials.ProductReview {
            Product.ID,
            avg(Rating) as AverageRating : Decimal(16, 2)
        }
        group by
            Product.ID;

    entity Products      as
        select from dmr2935.materials.Products
        mixin {
            ToStockAvailability : Association to dmr2935.materials.StockAvailability
                                      on ToStockAvailability.ID = $projection.StockAvailability;

            ToAverageRating     : Association to AverageRating
                                      on ToAverageRating.ID = ID;
        }
        into {
            *,
            ToAverageRating.AverageRating as Rating,
            case
                when
                    Quantity >= 8
                then
                    3
                when
                    Quantity > 0
                then
                    2
                else
                    1
            end as StockAvailability : Integer,
            ToStockAvailability
        }

}
