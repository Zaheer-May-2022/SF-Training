/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : Zaheer Khan
**/
@isTest (SeeAllData = false)
public with sharing class Utility_RowIteratorTest {

    @IsTest
    static void testMethodName() {

        String m_Data;
        String fileData = 'test';
        Integer m_index = 0;
        String m_rowDelimiter = '\n';

        
        Test.startTest();
            Utility_RowIterator utilityRowIt = new Utility_RowIterator(fileData);
            Utility_RowIterator utilityRowIt2 = new Utility_RowIterator(fileData, m_rowDelimiter);
            Boolean rethasNext = utilityRowIt.hasNext();
            String retNext = utilityRowIt.next();

            Boolean rethasNext2 = utilityRowIt2.hasNext();
            String retNext2 = utilityRowIt2.next();
            utilityRowIt2.Iterator();
        Test.stopTest();

        System.assertEquals(true, rethasNext, 'It Should Be true');
        System.assertEquals('test', retNext, 'It Should Be' + retNext);
        System.assertEquals(true, rethasNext2, 'It Should Be true');
        System.assertEquals('test', retNext2, 'It Should Be' + retNext2);
    }
}
