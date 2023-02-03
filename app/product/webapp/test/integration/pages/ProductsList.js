sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'dmr2935.product',
            componentId: 'ProductsList',
            entitySet: 'Products'
        },
        CustomPageDefinitions
    );
});