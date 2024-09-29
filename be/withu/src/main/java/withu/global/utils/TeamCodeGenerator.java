package withu.global.utils;

import java.util.Random;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class TeamCodeGenerator {
    private static final Random RANDOM = new Random();
    private static final Set<Integer> USED_CODES = ConcurrentHashMap.newKeySet();

    public static int generateUniqueCode() {
        int code;
        do {
            code = 100_000 + RANDOM.nextInt(900_000);
        } while (!USED_CODES.add(code));
        return code;
    }

    public static void releaseCode(int code) {
        USED_CODES.remove(code);
    }
}