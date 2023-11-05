import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabaseController {
  final supabase = Supabase.instance.client;

  getData() async {
    final data = await supabase.from('cities').select('name');
    return data;
  }

  getDataFilters() async {
    var myList = [];
    final data = await supabase.from('cities').select('name').filter(
        'arraycol', 'cs',
        '{"a","b"}') // Use Postgres array {} and 'cs' for contains.
        .filter('rangecol', 'cs',
        '(1,2]') // Use Postgres range syntax for range column.
        .filter(
        'id', 'in', '(6,7)') // Use Postgres list () and 'in' for in_ filter.
        .filter('id', 'cs',
        '{${myList.join(',')}}'); // You can insert a Dart array list.;
    return data;
  }

  getDataFiltered() async {
    final data = await supabase
        .from('cities')
        .select('name, country_id')
        .eq('name', 'The Shire') //equal
        .neq('name', 'The shire') //not equal
        .gt('country_id', 250) //greater than
        .gte('country_id', 250) //greater than or equal
        .lt('country_id', 250) //less than
        .lte('country_id', 250) //less than or equal
        .like('name', '%la%') //match pattern
        .ilike('name', '%la%') //matches case insensitive
        .is_('name', null) //is value
        .in_('name', ['Rio de Janeiro', 'San Francisco']) //in array
        .contains('main_exports',
        ['oil']) //Column contains every element in a value
    //more on than in $docs in consts

        ;
    return data;
  }

  insertData() async {
    await supabase
        .from('cities')
        .insert({'name': 'The Shire', 'country_id': 554});
  }

  updateData() async {
    await supabase
        .from('cities')
        .update({'name': 'Middle Earth'}).match({'name': 'Auckland'});
  }

  deleteData() async {
    await supabase.from('cities').delete().match({'id': 666});
  }
}
