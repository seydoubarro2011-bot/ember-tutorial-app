
import { module, test } from 'qunit';
import { setupRenderingTest } from 'supper-rentals/tests/helpers';
import { render } from '@ember/test-helpers';
import Jumbo from 'supper-rentals/components/jumbo';

module('Integration | Component | jumbo', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    await render(<template><Jumbo /></template>);

    assert.dom().hasText('');
  });

  test('it renders the content inside a jumbo header with a tomster', async function (assert) {
    await render(<template>
      <Jumbo>
        template block text
      </Jumbo>
      <Jumbo>Hello World</Jumbo>
    </template>);

    assert.dom().hasText('template block text Hello World');
    assert.dom('.jumbo').exists({ count: 2 });
    assert.dom('.jumbo:first-child').hasText('template block text');
    assert.dom('.jumbo:last-child').hasText('Hello World');
    assert.dom('.jumbo .tomster').exists({ count: 2 });
  });
});
