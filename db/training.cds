namespace com.training;

using {
    cuid,
    managed,
    Country,
} from '@sap/cds/common.cds';

// define type Gender : String enum {
//     male;
//     female;
// };

// entity Order {
//     clientGender : Gender;
//     status       : Integer enum {
//         submitted = 1;
//         fulfiller = 2;
//         shipped   = 3;
//         cancel    = -1;
//     };
//     priority : String @assert.range enum {
//         high;
//         medium;
//         low;
//     };
// }

// define type EmailsAddresses_01 : array of {
//     kind  : String;
//     Email : String;
// };

// define type EmailsAddresses_02 {
//     kind  : String;
//     Email : String;
// };

// define entity Emails {
//     email_01  :      EmailsAddresses_01;
//     email_02  : many EmailsAddresses_02;
//     email_03  : many {
//         kind  :      String;
//         Email :      String;
//     }
// }
// entity ParamProducts(pName : String)     as
//     select from Products {
//         Name,
//         Price,
//         Quantity,
//     }
//     where
//         Name = : pName;

// entity ProjParamProducts(pName : String) as projection on Products where Name = : pName;
// Asociación ternaria para replicar el many to many no existente en el uso del framework
entity Course {
    key ID      : UUID;
        Student : Association to many StudentCourse
                      on Student.Course = $self;
};

entity Student {
    key ID     : UUID;
        Course : Association to many StudentCourse
                     on Course.Student = $self;
};

entity StudentCourse {
    key ID      : UUID;
        Student : Association to Student;
        Course  : Association to Course;
};

entity Car {
    key ID                 : UUID;
        name               : String;
        virtual discount_1 : Decimal;
        virtual discount_2 : Decimal;
};

entity Orders {
    key ClientEmail : String(65);
        FirstName   : String(30);
        LastName    : String(30);
        CreatedOn   : Date;
        Reviewed    : Boolean;
        Approved    : Boolean;
        Country     : Country;
        status      : String(1);
};
