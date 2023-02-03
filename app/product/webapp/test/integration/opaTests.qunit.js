sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'dmr2935/product/test/integration/FirstJourney',
		'dmr2935/product/test/integration/pages/ProductsList',
		'dmr2935/product/test/integration/pages/ProductsObjectPage',
		'dmr2935/product/test/integration/pages/ReviewsObjectPage'
    ],
    function(JourneyRunner, opaJourney, ProductsList, ProductsObjectPage, ReviewsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('dmr2935/product') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheProductsList: ProductsList,
					onTheProductsObjectPage: ProductsObjectPage,
					onTheReviewsObjectPage: ReviewsObjectPage
                }
            },
            opaJourney.run
        );
    }
);