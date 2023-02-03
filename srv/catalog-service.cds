using {com.dmr2935 as dmr2935} from '../db/schema.cds';
using {com.training as training} from '../db/training.cds';

// service CatalogService {
//     entity Products          as projection on dmr2935.materials.Products;
//     entity Suppliers         as projection on dmr2935.sales.Suppliers;
//     entity Categories        as projection on dmr2935.materials.Categories;
//     entity StockAvailability as projection on dmr2935.materials.StockAvailability;
//     entity Currencies        as projection on dmr2935.materials.Currencies;
//     entity UnitOfMeasures    as projection on dmr2935.materials.UnitOfMeasures;
//     entity DimensionUnits    as projection on dmr2935.materials.DimensionUnits;
//     entity Months            as projection on dmr2935.sales.Months;
//     entity ProductReview     as projection on dmr2935.materials.ProductReview;
//     entity SalesData         as projection on dmr2935.sales.SalesData;
//     entity Order             as projection on dmr2935.sales.Orders;
//     entity OrderItems        as projection on dmr2935.sales.OrderItems;
// }

service CatalogService {

    entity Products          as
        select from dmr2935.reports.Products {
            ID,
            Name          as ProductName     @mandatory,
            Description                      @mandatory,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            Price                            @mandatory,
            Height,
            Width,
            Depth,
            Quantity                         @(
                mandatory,
                assert.range : [
                    0.00,
                    20.00
                ]
            ),
            UnitOfMeasure as ToUnitOfMeasure @mandatory,
            Currency      as ToCurrency      @mandatory,
            Currency.ID   as CurrencyId,
            Category      as ToCategory      @mandatory,
            Category.ID   as CategoryId,
            Category.Name as Category        @readonly,
            DimensionUnit as ToDimensionUnit,
            SalesData,
            Supplier,
            Reviews,
            Rating,
            StockAvailability,
            ToStockAvailability
        };

    entity Supplier          as
        select from dmr2935.sales.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct
        };

    @readonly
    entity Reviews           as
        select from dmr2935.materials.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            Product
        };

    @readonly
    entity SalesData         as
        select from dmr2935.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth.ID          as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as ToProduct
        };

    @readonly
    entity StockAvailability as
        select from dmr2935.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct
        };

    @readonly
    entity VH_Categories     as
        select from dmr2935.materials.Categories {
            ID   as Code,
            Name as Text,
        };

    @readonly
    entity VH_Currencies     as
        select from dmr2935.materials.Currencies {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_UnitOfMeasure  as
        select from dmr2935.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text
        };

    //Postfix
    @readonly
    entity VH_DimensionUnits as
        select
            ID          as Code,
            Description as Text
        from dmr2935.materials.DimensionUnits;
}


define service MyService {

    entity SuppliersProduct as
        select from dmr2935.materials.Products[Name = 'Bread']{
            *,
            Name,
            Description,
            Supplier.Address
        }
        where
            Supplier.Address.PostalCode = 98704;

    entity SuppliersToSales as
        select
            Supplier.Email,
            Category.Name,
            SalesData.Currency.ID,
            SalesData.Currency.Description
        from dmr2935.materials.Products;

    // INFIX
    entity EntityInfix      as
        select Supplier[Name = 'Exotic Liquids'].Phone from dmr2935.materials.Products
        where
            Products.Name = 'Bread';


    entity EntityJoin       as
        select Phone from dmr2935.materials.Products
        left join dmr2935.sales.Suppliers as supp
            on(
                supp.ID = Products.Supplier.ID
            )
            and supp.Name = 'Exotic Liquids'
        where
            Products.Name = 'Bread';
}


define service Reports {
    entity AverageRating as projection on dmr2935.reports.AverageRating;

    //Dos lógicas diferentes para hacer el cast
    entity EntityCasting as
        select
            cast(
                Price as      Integer
            )     as Price,
            Price as Price2 : Integer
        from dmr2935.materials.Products;

    entity EntityExists  as
        select from dmr2935.materials.Products {
            Name
        }
        where
            exists Supplier[Name = 'Exotic Liquids'];

}
