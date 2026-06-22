public class ValueCounter {
    public static Map<String, Integer> countOccurrences(List<String> inputList) {
        Map<String, Integer> valueCounts = new Map<String, Integer>();
        for (String str : inputList) {
            if (valueCounts.containsKey(str)) {
                valueCounts.put(str, valueCounts.get(str) + 1);
            } else {
                valueCounts.put(str, 1);
            }
        }
        return valueCounts;
    }
}