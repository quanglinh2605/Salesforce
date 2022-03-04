declare module "@salesforce/apex/AccountLightningCtrl.getAccountFromId" {
  export default function getAccountFromId(param: {accId: any}): Promise<any>;
}
declare module "@salesforce/apex/AccountLightningCtrl.saveData" {
  export default function saveData(param: {acc: any}): Promise<any>;
}
declare module "@salesforce/apex/AccountLightningCtrl.deleteAccount" {
  export default function deleteAccount(param: {accId: any}): Promise<any>;
}
declare module "@salesforce/apex/AccountLightningCtrl.searchAccount" {
  export default function searchAccount(param: {searchCondition: any}): Promise<any>;
}
