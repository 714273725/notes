package xy.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by Administrator on 2016/8/8.
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.CLASS)
public @interface SaveState {
}
