#include <iostream>
using namespace std;
#define MAX_SIZE 100

int CheckSumPossibility(int num, int arr[], int size);

int returnArray[MAX_SIZE];
static int index = 0;
static int with = -1;
static int func_call = 0;

int main()
{
    int arraySize;
    int arr[MAX_SIZE];
    int num;
    int returnVal;
    cin >> arraySize;
    cin >> num;
    for (int i = 0; i < arraySize; ++i)
    {
        cin >> arr[i];
    }
    returnVal = CheckSumPossibility(num, arr, arraySize);
    if (returnVal == 1)
    {
        cout << "Possible!" << endl;
        cout << "func call : " << func_call << endl;
        for (int i = 0; i < index; i++)
            cout << returnArray[i] << " ";
        cout << endl;
    }
    else
    {
        cout << "func call : " << func_call << endl;
        cout << "Not possible!" << endl;
    }
    //cout <<"*****"<<index<<"*****"<<endl;
    
}

int CheckSumPossibility(int num, int arr[], int size){
    func_call++;
    if (num == 0)
        return 1;
    if (size == 0){
        if (with == 1)
            returnArray[--index] = -1;
        return 0;}
    int control;
    if (arr[size-1] > num){
        with = -1;
        control = CheckSumPossibility(num, arr, size-1);}
    else{
        with = 1;
        returnArray[index++] = arr[size-1];
        control = CheckSumPossibility(num-arr[size-1], arr, size-1);
        if (control == 0 && with == -1){
            returnArray[--index] = -1;
            with = 1;
            control = CheckSumPossibility(num, arr, size-1);
            if (control == 0)
                with = -1;}}
    return control;}