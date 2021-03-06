import 'package:flutter_test/flutter_test.dart';
import 'package:challengeapp/container/app_context.dart';
import 'package:challengeapp/container/app_context_model.dart';

class CloseableBean with Closeable {
  bool closed = false;
  @override
  Future<bool> close() {
    closed = true;
    return Future.value(closed);
  }
}
class SimpleBean {
  bool closed = false;
  void close() {
    closed = true;
  }
}

void main() {
  AppContext subject;
  setUp(() {
    subject = AppContext();
  });

  test('Test get beans', () {
    var bean = SimpleBean();
    var closeableBean = CloseableBean();
    subject.add(bean).add(closeableBean);
    expect(subject.get<SimpleBean>(), bean);
    expect(subject.get<CloseableBean>(), closeableBean);
  });

  test('Test factory support', () {
    subject.addFactory((_) => SimpleBean()).add(CloseableBean());
    expect(subject.get<SimpleBean>(), isInstanceOf<SimpleBean>());
  });

  test('Test close support', () {
    var bean = SimpleBean();
    var closeableBean = CloseableBean();
    subject.add(bean).add(closeableBean);
    subject.addFactory((container) => CloseableBean);
    expect(subject.size, 3);

    subject.close();

    expect(bean.closed, false);
    expect(closeableBean.closed, true);
    expect(subject.size, 0);
  });
}