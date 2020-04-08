
# Insertion Sort Optimized

Insertion Sort Optimized (ISO) leverages several techniques to achive perfomance up to 5x faster than Swift.sort implementation of Timsort.


## Approach
Break an array into N subarrays initially containing just one element, iterate thru the original array and for each element find appropriate subarray and position in it. To find correct subarray and position in it binary search is used.

Step 1:
 - Divide original array in N subarrays (500). To achieve this, we’ll create a sorted array of pivots:
 - Iterate thru the original array with step N
 - Get an element at index N
 - Find correct insertion index in the array of pivots. Insert.
 - Using array of pivots create N subarrays - M. Each subarray will contain 1 element (the pivot/support). It is important to remember that M is automatically sorted because array of pivots is sorted.

Step 2:
 - Garbage buffer contains processed elements that haven’t been removed yet. Garbage size, K is max 1000 or 1% of the original array size
 - Start from  the last element in the original array and go backwards
 - For each element find an related subarray in M
 - Find an index to insert element in the found subarray
 - If the garbage counter reached the limit remove K last elements from the original array

Step 3:
 - Remove all the elements from the original array
 - Iterate thru M and append contents of each subarray to the original array (remember M is already sorted on Step 1)

Result original array is sorted.

## Analysis

Array size: n<br>
Subarray size: N (where optimal value for N ~500) <br>
Number of subarrays: K = n/N<br>

1. O(n/N)   - Creating array of pivots/supports
2. O(n)     - Iterating thru the original array one time 
3. O(log K) - Finding appropriate subarray
4. O(log N) - Finding position in the subarray
5. O(n/N)   - Combining sorted subarrays into final sorted array

Result: __O(n(logK + logN) + 2*(n/N))__ which is more than O(nlogn) by approximately 28%. Even though theoretical performance is slower compared to Swift.sort(), in practice __ISO__ can be up to 5 times faster. Typical (superficial) analysis only takes into considerations amount of itterations, and ignores cost and amount of modifying operations while they are playing a significant role. 

## Performance tests

|  Number of elements in array | 1_000    | 10_000  | 100_000 | 1_000_000  | 10_000_000 | 100_000_000 |
| ---------------------------- | -------- | --------|---------|------------|------------|-------------|
|    ISO                       | 0.0017   | 0.0155  | 0.1732  | 2.3348     | 28.2905    | 312.6586    |
|    Swift.sort                | 0.0088   | 0.0517  | 0.5778  | 7.6560     | 50.5603    | 561.9045    |
|    Delta (times x faster)    | 5.17x    | 3.33x   | 3.33x   | 3.27x      | 1.79x      | 1.79x       |

All tests were performed on 1.8 GHz Dual-Core Intel Core i5.

## Memory usage
ISO uses approximately 4% more memory than Swift.sort().

