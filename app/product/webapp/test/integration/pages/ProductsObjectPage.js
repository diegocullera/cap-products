sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'dmr2935.product',
            componentId: 'ProductsObjectPage',
            entitySet: 'Products'
        },
        CustomPageDefinitions
    );
});